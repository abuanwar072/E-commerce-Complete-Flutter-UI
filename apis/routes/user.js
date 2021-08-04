var express = require('express');
var router = express.Router();
var md5 = require('crypto-md5');
var async = require('async');
var passport = require('passport');
var flash = require('connect-flash');

/* GET login page. */
router.get('/login', function(req, res, next) {
	if (req.isAuthenticated()) return res.redirect('/user/account');
	
	res.render('user/login', { 
		message: req.flash('error'), 
		title: 'Login'
	});
});

router.post('/login', passport.authenticate('local', {
		successRedirect: '/',
		failureRedirect: '/user/login',
		failureFlash: true
	})
);

/* GET registration page. */
router.get('/register', function(req, res, next) {
	if (req.isAuthenticated()) return res.redirect('/user/account');
	
	res.render('user/register', { title: 'Register' });
});

/* POST Create User Account. */
router.post('/register/create', function(req, res, next) {
	var db = req.db;
		users = db.get('users');
	
	async.parallel([
		function(callback) {
			users.count({'email':req.body.email}, function (error, count) {
				user_exists = count;
				callback();
			});
		}
	], function(err) {
		if(req.body.email == '' || req.body.password == ''){
			res.send({
				'status': 0,
				'message': 'Please fill-up all required fields'
			});
		} else if(req.body.password != req.body.password2) {
			res.send({
				'status': 0,
				'message': 'Passwords do not match'
			});
		} else if(user_exists) {
			res.send({
				'status': 0,
				'message': 'User ' + req.body.email + ' already exists'
			});
		} else {
			users.insert({
				'email' : req.body.email,
				'password' : md5(req.body.password),
				'first_name' : req.body.first_name,
				'last_name' : req.body.last_name,
				'phone_number' : req.body.phone_number
				
			}, function (err, user) {
				if (err) {
					res.send({
						'status': 0,
						'message': err
					});
				} else {
					/* Login the user */
					req.login(user, function(err) {
						if (err) {
							res.send({
								'status': 0,
								'message': err
							});
						} else{
							res.send({
								'status': 1
							});
						}
					});
				}
			});
		}
	});
});

/* GET User Account page. */
router.get('/account', function(req, res, next) {
	if (!req.isAuthenticated()) return res.redirect('/user/login');
	
	var db = req.db;
		users = db.get('users');
	
	async.parallel([
		function(callback) {
			users.findOne(req.user._id.toString()).then((doc) => {
				user = doc;
				callback();
			});
		}	
	], function(err) {
		res.render('user/account', { 
			title: 'Account | ' + user.email,
			user: user
		});
	});
});

/* POST Update User Account Info. */
router.post('/account/update', function(req, res, next) {
	
	var db = req.db;
		users = db.get('users');
		posted_data = req.body;
		post_fields_array = {};
	
	if( posted_data.old_password != '' || posted_data.password_confirm != '' || posted_data.password != '' ){
		if( posted_data.password_confirm != posted_data.password ){
			return res.send({
				'status' : 0,
				'message' : 'New password do not match.'
			});
		} else if( md5(posted_data.old_password) != req.user.password ){
			return res.send({
				'status' : 0,
				'message' : 'Incorrect old password.'
			});
		}
	}
	
	async.parallel([
		function(callback) {
			/* Let's build an array out of available values that are posted */
			for (key in posted_data) {
				if( key != 'email' && key != 'old_password' && key != 'password_confirm' && key != 'password' ){
					post_fields_array[key] = posted_data[key];
				}
			}
			
			/* Check if we have a password to include in our update */
			if( posted_data.password != '' ){
				post_fields_array['password'] = md5(posted_data.password);
			}
			
			callback();
		},
		function(callback) {
			/* Update user profile */
			users.update(req.user._id, {
				'$set': post_fields_array
			});
			
			callback();
		}
	], function(err) {
		if(err){
			return res.send({
				'status' : 0,
				'message' : 'Update failed, please try again.'
			});
		}
		res.send({
			'status' : 1,
			'message' : 'Account successfully updated'
		});
	});
});

/* Handle Logout */
router.get('/logout', function(req, res) {
	req.logout();
	res.redirect('/');
});

module.exports = router;