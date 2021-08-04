var express = require('express');
var router = express.Router();

router.use('/products', require('./product'));
router.use('/user', require('./user'));
router.use('/user/products', require('./user_product'));

/* GET home page. */
router.get('/', function(req, res, next) {
	res.render('front/index', { title: 'NodeJS with MongoDB' });
});

module.exports = router;
