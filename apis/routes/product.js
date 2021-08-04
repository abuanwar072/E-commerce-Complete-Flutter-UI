var express = require('express');
var router = express.Router();
var async = require('async');

/* GET products page. */
router.get('/', function(req, res, next) {
	
	var collection = req.db.get('products');
	collection.find({},{},function(e,docs){
		res.render('front/products', {
			'products' : docs,
			'title' : 'Products'
		});
	});
});

router.post('/view-front', function(req, res){
	
	/* Set our internal DB variable */
    var db = req.db;
	
		/* Set our collection */
		products = db.get('products');
		
		pag_content = '';
		pag_navigation = '';
	
		page = parseInt(req.body.data.page); /* Page we are currently at */
		name = req.body.data.name; /* Name of the column name we want to sort */
		sort = req.body.data.sort == 'ASC' ? 1 : -1; /* Order of our sort (DESC or ASC) */
		max = parseInt(req.body.data.max); /* Number of items to display per page */
		search = req.body.data.search; /* Keyword provided on our search box */
		
		cur_page = page;
		page -= 1;
		per_page = max ? max : 16; 
		previous_btn = true;
		next_btn = true;
		first_btn = true;
		last_btn = true;
		start = page * per_page;
	
		where_search = {};
	
	/* Check if there is a string inputted on the search box */
	if( search != '' ){
		/* If a string is inputted, include an additional query logic to our main query to filter the results */
		var filter = new RegExp(search, 'i');
		where_search = {
			'$or' : [
				{'name' : filter},
				{'price' : filter},
			]
		}
	}
	
	var all_items = '';
	var count = '';
	var sort_query = {};
	
	/* We use async task to make sure we only return data when all queries completed successfully */
	async.parallel([
		function(callback) {
			/* Use name and sort variables as field names */
			sort_query[name] = sort;
			
			/* Retrieve all the posts */
			products.find( where_search, {
				limit: per_page,
				skip: start,
				sort: sort_query
				
			}, function(err, docs){
				if (err) throw err;
				// console.log(docs);
				all_items = docs;
				callback();
				
			});
		},
		function(callback) {
			products.count(where_search, function(err, doc_count){
				if (err) throw err;
				// console.log(count);
				count = doc_count;
				callback();
			});
		}
	], function(err) { //This is the final callback
		/* Check if our query returns anything. */
		if( count ){
			for (var key in all_items) {
				pag_content += '<div class="col-sm-3 item-' + all_items[key]._id + '">' + 
					'<div class="panel panel-default">' + 
						'<div class="panel-heading item-name">' + 
							all_items[key].name +
						'</div>' + 
						'<div class="panel-body p-0 p-b">' + 
							'<a href="/products/' + all_items[key]._id + '"><img src="/images/uploads/' + all_items[key].featured_image + '" width="100%" class="img-responsive item-featured" /></a>' + 
							'<div class="list-group m-0">' + 
								'<div class="list-group-item b-0 b-t">' + 
									'<i class="fa fa-calendar-o fa-2x pull-left ml-r"></i>' + 
									'<p class="list-group-item-text">Price</p>' + 
									'<h4 class="list-group-item-heading">$<span class="item-price">' + parseFloat(all_items[key].price).toFixed(2) + '</span></h4>' + 
								'</div>' + 
								'<div class="list-group-item b-0 b-t">' + 
									'<i class="fa fa-calendar fa-2x pull-left ml-r"></i>' + 
									'<p class="list-group-item-text">On Stock</p>' + 
									'<h4 class="list-group-item-heading item-stock">' + all_items[key].stock + '</h4>' + 
								'</div>' + 
							'</div>' + 
						'</div>' + 
						'<div class="panel-footer">' + 
							'</p><a href="products/' + all_items[key]._id + '" class="btn btn-success btn-block">View Item</a></p>' + 
						 '</div>' + 
					'</div>' + 
				'</div>';
			}
		}
		
		pag_content = pag_content + "<br class = 'clear' />";
		
		no_of_paginations = Math.ceil(count / per_page);

		if (cur_page >= 7) {
			start_loop = cur_page - 3;
			if (no_of_paginations > cur_page + 3)
				end_loop = cur_page + 3;
			else if (cur_page <= no_of_paginations && cur_page > no_of_paginations - 6) {
				start_loop = no_of_paginations - 6;
				end_loop = $no_of_paginations;
			} else {
				end_loop = no_of_paginations;
			}
		} else {
			start_loop = 1;
			if (no_of_paginations > 7)
				end_loop = 7;
			else
				end_loop = no_of_paginations;
		}
		  
		pag_navigation += "<ul>";

		if (first_btn && cur_page > 1) {
			pag_navigation += "<li p='1' class='active'>First</li>";
		} else if (first_btn) {
			pag_navigation += "<li p='1' class='inactive'>First</li>";
		} 

		if (previous_btn && cur_page > 1) {
			pre = cur_page - 1;
			pag_navigation += "<li p='" + pre + "' class='active'>Previous</li>";
		} else if (previous_btn) {
			pag_navigation += "<li class='inactive'>Previous</li>";
		}
		for (i = start_loop; i <= end_loop; i++) {

			if (cur_page == i)
				pag_navigation += "<li p='" + i + "' class = 'selected' >" + i + "</li>";
			else
				pag_navigation += "<li p='" + i + "' class='active'>" + i + "</li>";
		}
		
		if (next_btn && cur_page < no_of_paginations) {
			nex = cur_page + 1;
			pag_navigation += "<li p='" + nex + "' class='active'>Next</li>";
		} else if (next_btn) {
			pag_navigation += "<li class='inactive'>Next</li>";
		}

		if (last_btn && cur_page < no_of_paginations) {
			pag_navigation += "<li p='" + no_of_paginations + "' class='active'>Last</li>";
		} else if (last_btn) {
			pag_navigation += "<li p='" + no_of_paginations + "' class='inactive'>Last</li>";
		}

		pag_navigation = pag_navigation + "</ul>";
		
		var response = {
			'content': pag_content,
			'navigation' : pag_navigation
		};
		
		res.send(response);
		
	});

});

/* GET Single Product Data. */
router.get('/:id', function(req, res, next) {
	
	var db = req.db;
		item_id = req.params.id
		item_id_check = item_id.match(/^[0-9a-fA-F]{24}$/);
		products = db.get('products');
		item_details = '';
	
	/* Check if the object id is valid */
	if( item_id_check ){
		async.parallel([
			function(callback) {
				products.findOne(item_id).then((doc) => {
					item_details = doc;
					callback();
				});
			}	
		], function(err) {
			
			var images_array = [];
			var len = item_details.images.length;
			for (var i = 0; i < len; i++) {
				images_array.push({
					small: '/images/uploads/' + item_details.images[i],
					big: '/images/uploads/' + item_details.images[i]
				});
			}
			
			res.render('front/products-single', { 
				title: item_details.name,
				item: item_details,
				item_images: JSON.stringify(images_array)
			});
		});
		
	} else {
		res.status(404).send('Invalid Item ID');
	}
});

module.exports = router;