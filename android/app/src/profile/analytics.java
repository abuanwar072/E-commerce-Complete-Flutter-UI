/*
 * Copyright (c) 2009, Balazs Lecz <leczbalazs@gmail.com>
 * Copyright (c) 2015, Amplitude Mobile Analytics
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *     * Redistributions in binary form must reproduce the above copyright notice,
 *       this list of conditions and the following disclaimer in the documentation
 *       and/or other materials provided with the distribution.
 *
 *     * Neither the names of Balazs Lecz or Amplitude Mobile Analytics nor the names of
 *       contributors may be used to endorse or promote products derived from this
 *       software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

package com.lecz.android.tiltmazes;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.hardware.SensorListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.widget.TextView;

import com.amplitude.api.Amplitude;
import com.amplitude.api.Identify;

import org.json.JSONException;
import org.json.JSONObject;

public class GameEngine {
    private SensorManager mSensorManager;
    private Vibrator mVibrator;

    private static float ACCEL_THRESHOLD = 2;
    private float mAccelX = 0;
    private float mAccelY = 0;
    @SuppressWarnings("unused")
    private float mAccelZ = 0;

    private Handler mHandler;

    private Map mMap;
    private Ball mBall;
    private int mCurrentMap = 0;
    private int mMapToLoad = 0;
    private int mStepCount = 0;

    private Direction mCommandedRollDirection = Direction.NONE;

    private TextView mMazeNameLabel;
    private TextView mRemainingGoalsLabel;
    private TextView mStepsView;
    private MazeView mMazeView;

    private final AlertDialog mMazeSolvedDialog;
    private final AlertDialog mAllMazesSolvedDialog;

    private boolean mSensorEnabled = true;

    private TiltMazesDBAdapter mDB;

    private final SensorListener mSensorAccelerometer = new SensorListener() {

        public void onSensorChanged(int sensor, float[] values) {
            if (!mSensorEnabled) return;

            mAccelX = values[0];
            mAccelY = values[1];
            mAccelZ = values[2];

            mCommandedRollDirection = Direction.NONE;
            if (Math.abs(mAccelX) > Math.abs(mAccelY)) {
                if (mAccelX < -ACCEL_THRESHOLD) mCommandedRollDirection = Direction.LEFT;
                // FIXME(leczbalazs) elseif
                if (mAccelX > ACCEL_THRESHOLD) mCommandedRollDirection = Direction.RIGHT;
            } else {
                if (mAccelY < -ACCEL_THRESHOLD) mCommandedRollDirection = Direction.DOWN;
                // FIXME(leczbalazs) elseif
                if (mAccelY > ACCEL_THRESHOLD) mCommandedRollDirection = Direction.UP;
            }

            if (mCommandedRollDirection != Direction.NONE && !mBall.isRolling()) {
                rollBall(mCommandedRollDirection);
            }
        }

        public void onAccuracyChanged(int sensor, int accuracy) {
        }
    };


    public GameEngine(Context context) {
        // Open maze database
        mDB = new TiltMazesDBAdapter(context).open();
        mCurrentMap = mDB.getFirstUnsolved();

        // Request vibrator service
        mVibrator = (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);

        // Register the sensor listener
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        mSensorManager.registerListener(mSensorAccelerometer, SensorManager.SENSOR_ACCELEROMETER,
                SensorManager.SENSOR_DELAY_GAME);

        mMap = new Map(MapDesigns.designList.get(mCurrentMap));

        // Create ball
        mBall = new Ball(this, mMap,
                mMap.getInitialPositionX(),
                mMap.getInitialPositionY());

        // Congratulations dialog
        mMazeSolvedDialog = new AlertDialog.Builder(context)
                .setCancelable(true)
                .setIcon(android.R.drawable.ic_dialog_info)
                .setTitle("Congratulations!")
                .setPositiveButton("Go to next maze!", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        dialog.cancel();
                        sendEmptyMessage(Messages.MSG_MAP_NEXT);
                    }
                })
                .create();

        // Final congratulations dialog
        mAllMazesSolvedDialog = new AlertDialog.Builder(context)
                .setCancelable(true)
                .setIcon(android.R.drawable.ic_dialog_alert)
                .setTitle("Congratulations!")
                .setPositiveButton("OK!", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        dialog.cancel();
                        sendEmptyMessage(Messages.MSG_MAP_NEXT);
                    }
                })
                .create();

        // Create message handler
        mHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case Messages.MSG_INVALIDATE:
                        mMazeView.invalidate();
                        return;

                    case Messages.MSG_REACHED_GOAL:
                        mRemainingGoalsLabel.setText("" + mMap.getGoalCount());
                        mRemainingGoalsLabel.invalidate();
                        vibrate(100);

                        if (mMap.getGoalCount() == 0) {
                            // Solved!
                            mDB.updateMaze(mCurrentMap, mStepCount);

                            // Update the user properties with number of mazes completed.
                            JSONObject userProperties = new JSONObject();
                            try {
                                userProperties.put("Mazes Completed", mDB.solvedMazes().getCount());
                            } catch (JSONException exception) {
                            }
                            Amplitude.getInstance().setUserProperties(userProperties);

                            // Track the maze completion in amplitude
                            JSONObject eventProperties = new JSONObject();
                            try {
                                eventProperties.put("Maze", mMap.getName());
                                eventProperties.put("Steps", mStepCount);
                            } catch (JSONException exception) {
                            }

                            Amplitude.getInstance().logEvent("Maze Completed", eventProperties);
                            Amplitude.getInstance().identify(new Identify().add("total steps", mStepCount));
                            Amplitude.getInstance().identify(new Identify().add("mazes completed", 1));
                            Long tsLong = System.currentTimeMillis() / 1000;
                            Amplitude.getInstance().identify(new Identify().setOnce("first maze completed time", tsLong));

                            if (mDB.unsolvedMazes().getCount() == 0) {
                                mAllMazesSolvedDialog.setMessage(
                                        "Mad props!\nYou have solved all the mazes!\n" +
                                                "Now go back and try to solve them in fewer steps! :)");
                                mAllMazesSolvedDialog.show();
                            } else {
                                mMazeSolvedDialog.setMessage(
                                        "You have solved maze "
                                                + mMap.getName()
                                                + " in " + mStepCount + " steps."
                                );
                                mMazeSolvedDialog.show();
                            }
                        }
                        return;

                    case Messages.MSG_REACHED_WALL:
                        vibrate(12);
                        return;

                    case Messages.MSG_RESTART:
                        loadMap(mCurrentMap);
                        return;

                    case Messages.MSG_MAP_PREVIOUS:
                    case Messages.MSG_MAP_NEXT:
                        switch (msg.what) {
                            case (Messages.MSG_MAP_PREVIOUS):
                                if (mCurrentMap == 0) {
                                    // Wrap around
                                    mMapToLoad = MapDesigns.designList.size() - 1;
                                } else {
                                    mMapToLoad = (mCurrentMap - 1) % MapDesigns.designList.size();
                                }
                                break;

                            case (Messages.MSG_MAP_NEXT):
                                mMapToLoad = (mCurrentMap + 1) % MapDesigns.designList.size();
                                break;
                        }

                        loadMap(mMapToLoad);
                        return;
                }

                super.handleMessage(msg);
            }
        };
    }

    public void loadMap(int mapID) {
        mCurrentMap = mapID;
        mBall.stop();
        mMap = new Map(MapDesigns.designList.get(mCurrentMap));
        mBall.setMap(mMap);
        mBall.setX(mMap.getInitialPositionX());
        mBall.setY(mMap.getInitialPositionY());
        mBall.setXTarget(mMap.getInitialPositionX());
        mBall.setYTarget(mMap.getInitialPositionY());
        mMap.init();

        mStepCount = 0;

        mMazeNameLabel.setText(mMap.getName());
        mMazeNameLabel.invalidate();

        mRemainingGoalsLabel.setText("" + mMap.getGoalCount());
        mRemainingGoalsLabel.invalidate();

        mStepsView.setText("" + mStepCount);
        mStepsView.invalidate();

        mMazeView.calculateUnit();
        mMazeView.invalidate();
    }

    public void setMazeNameLabel(TextView mazeNameLabel) {
        mMazeNameLabel = mazeNameLabel;
    }

    public void setRemainingGoalsLabel(TextView remainingGoalsLabel) {
        mRemainingGoalsLabel = remainingGoalsLabel;
    }

    public void setTiltMazesView(MazeView mazeView) {
        mMazeView = mazeView;
        mBall.setMazeView(mazeView);
    }

    public void setStepsLabel(TextView stepsView) {
        mStepsView = stepsView;
    }

    public void sendEmptyMessage(int msg) {
        mHandler.sendEmptyMessage(msg);
    }

    public void sendMessage(Message msg) {
        mHandler.sendMessage(msg);
    }

    public void registerListener() {
        mSensorManager.registerListener(mSensorAccelerometer, SensorManager.SENSOR_ACCELEROMETER,
                SensorManager.SENSOR_DELAY_GAME);
    }

    public void unregisterListener() {
        mSensorManager.unregisterListener(mSensorAccelerometer);
    }

    public void rollBall(Direction dir) {
        if (mBall.roll(dir)) mStepCount++;
        mStepsView.setText("" + mStepCount);
        mStepsView.invalidate();
    }

    public Ball getBall() {
        return mBall;
    }

    public Map getMap() {
        return mMap;
    }

    public boolean isSensorEnabled() {
        return mSensorEnabled;
    }

    public void toggleSensorEnabled() {
        mSensorEnabled = !mSensorEnabled;
    }

    public void vibrate(long milliseconds) {
        mVibrator.vibrate(milliseconds);
    }

    public void saveState(Bundle icicle) {
        mBall.stop();

        icicle.putInt("map.id", mCurrentMap);

        int[][] goals = mMap.getGoals();
        int sizeX = mMap.getSizeX();
        int sizeY = mMap.getSizeY();
        int[] goalsToSave = new int[sizeX * sizeY];
        for (int y = 0; y < sizeY; y++)
            for (int x = 0; x < sizeX; x++)
                goalsToSave[y + x * sizeX] = goals[y][x];
        icicle.putIntArray("map.goals", goalsToSave);

        icicle.putInt("stepcount", mStepCount);

        icicle.putInt("ball.x", Math.round(mBall.getX()));
        icicle.putInt("ball.y", Math.round(mBall.getY()));
    }

    public void restoreState(Bundle icicle, boolean sensorEnabled) {
        if (icicle != null) {
            int mapID = icicle.getInt("map.id", -1);
            if (mapID == -1) return;
            loadMap(mapID);

            int[] goals = icicle.getIntArray("map.goals");
            if (goals == null) return;

            int sizeX = mMap.getSizeX();
            int sizeY = mMap.getSizeY();
            for (int y = 0; y < sizeY; y++)
                for (int x = 0; x < sizeX; x++)
                    mMap.setGoal(x, y, goals[y + x * sizeX]);

            mBall.setX(icicle.getInt("ball.x"));
            mBall.setY(icicle.getInt("ball.y"));

            // We have probably moved the ball, so invalidate the Maze View
            mMazeView.invalidate();

            mStepCount = icicle.getInt("stepcount", 0);
        }
        mRemainingGoalsLabel.setText("" + mMap.getGoalCount());
        mRemainingGoalsLabel.invalidate();

        mStepsView.setText("" + mStepCount);
        mStepsView.invalidate();

        mSensorEnabled = sensorEnabled;
    }
}
