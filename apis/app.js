var express = require('express');
var session = require('express-session');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var flash = require('connect-flash');
var md5 = require('crypto-md5');

/* MongoDB connection */
var mongo = require('mongodb');
var monk = require('monk');
var db = monk('localhost:27017/nodetest1'); // 27017 is the default port for our MongoDB instance. 
var users = db.get('users');

var routes = require('./routes/index');

var app = express();

/* Setup socket.io and express to run on same port (3100) */
var server = require('http').Server(app);
var io = require('socket.io')(server);

server.listen(3100);

/* Realtime trigger */
io.sockets.on('connection', function (socket) {
    socket.on('send', function (data) {
        io.sockets.emit('message', data);
    });
});

/* Define some globals that will be made accessible all through out the application */
global.root_dir = path.resolve(__dirname);
global.uploads_dir = root_dir + '/public/images/uploads/';

/* view engine setup */
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

/* Make the response uncompressed */
app.locals.pretty = true;

/* uncomment after placing your favicon in /public */
/* app.use(favicon(path.join(__dirname, 'public', 'favicon.ico'))); */
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(flash());
app.use(session({
    secret: 'secret cat',
    resave: true,
    saveUninitialized: true
}));
app.use(passport.initialize());
app.use(passport.session());

passport.use(new LocalStrategy({
		/* Define custom fields for passport */
		usernameField : 'email',
        passwordField : 'password'
	}, 
	function(email, password, done) {	
		/* validate email and password */
		users.findOne({email: email}, function(err, user) {
			if (err) { return done(err); }
			if (!user) {
				return done(null, false, {message: 'Incorrect username.'});
			}
			if (user.password != md5(password)) {
				return done(null, false, {message: 'Incorrect password.'});
			}
			/* if everything is correct, let's pass our user object to the passport.serializeUser */
			return done(null, user);
		});
	}
));

passport.serializeUser(function(user, done) {
    /* Attach to the session as req.session.passport.user = { email: 'test@test.com' } */
	/* The email key will be later used in our passport.deserializeUser function */
	done(null, user.email);
});

passport.deserializeUser(function(email, done) {
	users.findOne({email: email}, function(err, user) {
		/* The fetched "user" object will be attached to the request object as req.user */
		done(err, user);
	});
});


app.use(function(req, res, next){
    req.db = db; /* Make our db accessible to our router */
	res.locals.user = req.user; /* Make our user object accessible in all our templates. */
	next();
});

app.use('/', routes);

/* catch 404 and forward to error handler */
app.use(function(req, res, next) {
	var err = new Error('Not Found');
	err.status = 404;
	next(err);
});

/* error handlers */

/* development error handler */
/* will print stacktrace */
if (app.get('env') === 'development') {
	app.use(function(err, req, res, next) {
		res.status(err.status || 500);
		res.render('error', {
			message: err.message,
			error: err
		});
	});
}

/* production error handler */
/* no stacktraces leaked to user */
app.use(function(err, req, res, next) {
	res.status(err.status || 500);
	res.render('error', {
		message: err.message,
		error: {}
	});
});


module.exports = app;