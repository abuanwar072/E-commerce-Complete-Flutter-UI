/**
 * App Class 
 *
 * @author		Carl Victor Fontanos
 * @author_url	www.carlofontanos.com
 *
 */

/**
 * Setup a App namespace to prevent JS conflicts.
 */

var socket = io.connect('http://localhost:3100');
var app = {
		
    
	Posts: function() {
		
		/**
		 * This method contains the list of functions that needs to be loaded
		 * when the "Posts" object is instantiated.
		 *
		 */
		this.init = function() {
			// this.loaded_posts_pagination();
			this.get_all_items_pagination();
			this.get_user_items_pagination();
			this.add_post();
			this.update_post();
			this.delete_post();
			this.unset_image();
			this.set_featured_image();
			this.set_imageviewer();
		}
		
		/**
		 * Load user items pagination.
		 */
		this.get_user_items_pagination = function() {
			
			_this = this;
			
			/* Check if our hidden form input is not empty, meaning it's not the first time viewing the page. */
			if($('form.post-list input').val()){
				/* Submit hidden form input value to load previous page number */
				data = JSON.parse($('form.post-list input').val());
				_this.ajax_get_user_items_pagination(data.page, data.th_name, data.th_sort);
			} else {
				/* Load first page */
				_this.ajax_get_user_items_pagination(1, 'name', 'ASC');
			}
			
			var th_active = $('.table-post-list th.active');
			var th_name = $(th_active).attr('id');
			var th_sort = $(th_active).hasClass('DESC') ? 'DESC': 'ASC';
						
			/* Search */
			$('body').on('click', '.post_search_submit', function(){
				_this.ajax_get_user_items_pagination(1, th_name, th_sort);
			});
			/* Search when Enter Key is triggered */
			$(".post_search_text").keyup(function (e) {
				if (e.keyCode == 13) {
					_this.ajax_get_user_items_pagination(1, th_name, th_sort);
				}
			});
			
			/* Pagination Clicks   */                  
			$('body').on('click', '.pagination-nav li.active', function(){
				var page = $(this).attr('p');
				var current_th_active = $('.table-post-list th.active');
				var current_sort = $(current_th_active).hasClass('DESC') ? 'DESC': 'ASC';
				var current_name = $(current_th_active).attr('id');
				_this.ajax_get_user_items_pagination(page, current_name, current_sort);                
			}); 

			/* Sorting Clicks */
			$('body').on('click', '.table-post-list th', function(e) {
				e.preventDefault();                             
				var th_name = $(this).attr('id');
													
				if(th_name){
					/* Remove all TH tags with an "active" class */
					if($('.table-post-list th').removeClass('active')) {
						/* Set "active" class to the clicked TH tag */
						$(this).addClass('active');
					}
					if(!$(this).hasClass('DESC')){
						_this.ajax_get_user_items_pagination(1, th_name, 'DESC');
						$(this).addClass('DESC');
					} else {
						_this.ajax_get_user_items_pagination(1, th_name, 'ASC');
						$(this).removeClass('DESC');
					}
				}
			});
		}
		
		/**
		 * AJAX user items pagination.
		 */
		this.ajax_get_user_items_pagination = function(page, th_name, th_sort){
			
			if($(".pagination-container").length > 0 && $(".products-view-user").length > 0){
				$(".pagination-container").html('<img src="/images/loading.gif" class="ml-tb" />');
				
				var post_data = {
					page: page,
					search: $('.post_search_text').val(),
					th_name: th_name,
					th_sort: th_sort,
					max: $('.post_max').val(),
				};
				
				$('form.post-list input').val(JSON.stringify(post_data));
				
				var data = {
					action: "demo_load_my_posts",
					data: JSON.parse($('form.post-list input').val())
				};
				
				$.ajax({
					url: '/user/products/view',
					type: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(data),
					success: function (response) {
						
						if($(".pagination-container").html(response.content)){
							$('.pagination-nav').html(response.navigation);
							$('.table-post-list th').each(function() {
								/* Append the button indicator */
								$(this).find('span.glyphicon').remove();    
								if($(this).hasClass('active')){
									if(JSON.parse($('form.post-list input').val()).th_sort == 'DESC'){
										$(this).append(' <span class="glyphicon glyphicon-chevron-down pull-right"></span>');
									} else {
										$(this).append(' <span class="glyphicon glyphicon-chevron-up pull-right"></span>');
									}
								}
							});
						}
					}
				});
			}
		}
		
		/**
		 * Load front-end items pagination.
		 */
		this.get_all_items_pagination = function() {
			
			_this = this;
			
			/* Check if our hidden form input is not empty, meaning it's not the first time viewing the page. */
			if($('form.post-list input').val()){
				/* Submit hidden form input value to load previous page number */
				data = JSON.parse($('form.post-list input').val());
				_this.ajax_get_all_items_pagination(data.page, data.name, data.sort);
			} else {
				/* Load first page */
				_this.ajax_get_all_items_pagination(1, $('.post_name').val(), $('.post_sort').val());
			}
					
			/* Search */
			$('body').on('click', '.post_search_submit', function(){
				_this.ajax_get_all_items_pagination(1, $('.post_name').val(), $('.post_sort').val());
			});
			/* Search when Enter Key is triggered */
			$(".post_search_text").keyup(function (e) {
				if (e.keyCode == 13) {
					_this.ajax_get_all_items_pagination(1, $('.post_name').val(), $('.post_sort').val());
				}
			});
			
			/* Pagination Clicks   */                  
			$('body').on('click', '.pagination-nav li.active', function(){
				var page = $(this).attr('p');
				_this.ajax_get_all_items_pagination(page, $('.post_name').val(), $('.post_sort').val());                
			});
		}
		
		/**
		 * AJAX front-end items pagination.
		 */
		this.ajax_get_all_items_pagination = function(page, order_by_name, order_by_sort){
			
			if($(".pagination-container").length > 0 && $('.products-view-all').length > 0 ){
				$(".pagination-container").html('<img src="images/loading.gif" class="ml-tb" />');
				
				var post_data = {
					page: page,
					search: $('.post_search_text').val(),
					name: order_by_name,
					sort: order_by_sort,
					max: $('.post_max').val(),
				};
				
				$('form.post-list input').val(JSON.stringify(post_data));
				
				var data = {
					action: 'get-all-products',
					data: JSON.parse($('form.post-list input').val())
				};
				
				$.ajax({
					url: 'products/view-front',
					type: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(data),
					success: function (response) {
						
						if($(".pagination-container").html(response.content)){
							$('.pagination-nav').html(response.navigation);
							$('.table-post-list th').each(function() {
								/* Append the button indicator */
								$(this).find('span.glyphicon').remove();    
								if($(this).hasClass('active')){
									if(JSON.parse($('form.post-list input').val()).th_sort == 'DESC'){
										$(this).append(' <span class="glyphicon glyphicon-chevron-down pull-right"></span>');
									} else {
										$(this).append(' <span class="glyphicon glyphicon-chevron-up pull-right"></span>');
									}
								}
							});
						}
					}
				});
			}
		}
		
		/**
		 * Submit updated data via ajax using jquery form plugin
		 */
		this.update_post = function(){
			$('.update-product').ajaxForm({
				beforeSerialize: function() {
					update_ckeditor_instances();
					wave_box('on');
				},
				success: function(response, textStatus, xhr, form) {
					if(response.status == 0){
						if($.isArray(response.errors)){
							$.each(response.errors, function (key, error_nessage) {
								Lobibox.notify('error', {msg: error_nessage, size: 'mini', sound: false});
							});
						}
					}
					if(response.status == 1){
						if(response.message){
							Lobibox.notify('success', {msg: response.message, size: 'mini', sound: false});
						}
						
						socket.emit('send', { message: $('.update-product').serializeObject() } );
					}
					if(response.images){
						$('.image-input').val('');
						$('.no-item-images').remove();
						$.each(response.images, function (index, image) {
							$('.images-section').append(
								'<div class = "col-sm-3">' + 
									'<span class="unset-image glyphicon glyphicon-remove text-danger lead m-0 c-p" id="unset-' + image + '" title="Delete image"></span>' + 
									'<span class="set-featured-image glyphicon glyphicon-star-empty text-warning lead m-0 c-p" id="featured-' + image + '" title="Set as featured image"></span>' + 
									'<img src = "/images/uploads/' + image + '" class = "img-thumbnail img-responsive" />' + 
								'</div>'
							);
						});
					}
					wave_box('off');
				}
            });
		}
		
		/**
		 * Submit new product data via ajax using jquery form plugin
		 */
		this.add_post = function(){
			$('.create-product').ajaxForm({
				beforeSubmit: function(arr, $form, options) {
					var proceed = true;
					
					$('input.required').each(function(index) {
						if($(this).val() == ''){
							Lobibox.notify('error', {msg: 'Please fill-up the required fields', size: 'mini', sound: false});
							proceed = false;
							return false;
						}
					});
					
					return proceed;
				},
				beforeSerialize: function() {
					update_ckeditor_instances();
				},
				success: function(response, textStatus, xhr, form) {
					if(response == 0){
						Lobibox.notify('error', {msg: 'Failed to create the product, please try again', size: 'mini', sound: false});
					} else {
						window.location.href = '/user/products/edit/' + response + '?status=created';
					}
				}
            });
			
			if(get_url_value('status') == 'created'){
				Lobibox.notify('success', {msg: 'Item successfully created, you may continue editing this product.', size: 'mini', sound: false});
			}
		}
		
		/**
		 * Handles the deletion of a single post
		 */
		this.delete_post = function(){
			$('body').on('click', '.delete-product', function(e) {
				e.preventDefault();
				
				var item = $(this);
				var data = { 
					item_id: item.attr('item_id')
				}
				
				$.ajax({
					url: '/user/products/delete',
					type: 'POST',
					data: data,
					success: function (response) {
						if(response == 0){
							Lobibox.notify('error', {msg: 'Delete failed, please try again', size: 'mini', sound: false});
						} else if(response == 1){
							item.parents('tr').css('background', '#add9ff').fadeOut('fast');
							Lobibox.notify('success', {msg: 'Deleted Successfully', size: 'mini', sound: false});
						}
					}
				});
			});
			
		}
		
		/**
		 * Sends an AJAX request to delete the image.
		 */
		this.unset_image = function() {
			$('body').on('click', '.unset-image', function(e) {
				e.preventDefault();
				wave_box('on');
				
				var parent_element = $(this).parent();
				
				$.ajax({
					url: '/user/products/image/unset',
					type: 'POST',
					data: {
						'action': 'unset-image',
						'item_id': $('.item-edit').attr('id').split('-')[1],
						'image': this.id.split('-')[1]
					},
					success: function (response) {
						if(response.status == 1){
							parent_element.fadeOut();
							Lobibox.notify('success', {msg: response.message, size: 'mini', sound: false});
						} else {
							Lobibox.notify('error', {msg: response.message, size: 'mini', sound: false});
						}
						wave_box('off');
					}
				});
			});
		}
		
		/**
		 * Sends an AJAX request to set the image as featured.
		 */
		this.set_featured_image = function() {
			$('body').on('click', '.set-featured-image', function(e) {
				e.preventDefault();
				wave_box('on');
				
				var _this = this;
				var image_featured_id = this.id.split('-')[1];
					
				if( $(this).hasClass('glyphicon-star') ){
					Lobibox.notify('error', {msg: 'The image you clicked is already the featured image.', size: 'mini', sound: false});
					wave_box('off');
					
				} else {
					$.ajax({
						url: '/user/products/image/set-featured',
						type: 'POST',
						data: {
							'action': 'set-featured-image',
							'item_id': $('.item-edit').attr('id').split('-')[1],
							'image': image_featured_id
						},
						datatype: 'JSON',
						success: function (response) {
							if(response.status == 1){
								if($('.images-section').find('span.glyphicon-star').switchClass('glyphicon-star', 'glyphicon-star-empty').removeAttr('style')){
									$(_this).switchClass('glyphicon-star-empty', 'glyphicon-star').css('color', '#E4C317');
									Lobibox.notify('success', {msg: response.message, size: 'mini', sound: false});
								}
							} else {
								Lobibox.notify('error', {msg: response.message, size: 'mini', sound: false});
							}
							
							socket.emit('send', { message: { featured: image_featured_id, id: $('.item-edit').attr('id').split('-')[1] } } );
							
							wave_box('off');
						}
					});
				}
			});
		}
		
		/**
		 * Load ImageViewer plugin
		 */	
		this.get_imageviewer_image = function(images, curImageIdx, viewer, curSpan){
			var imgObj = images[curImageIdx - 1];
			
			viewer.load(imgObj.small, imgObj.big);
			curSpan.html(curImageIdx);
		}
		
		/**
		 * Initialize imageviewer plugin
		 */
		this.set_imageviewer = function() {
			
			_this = this;
			
			if($('input.item-images-json').length){
				var images = JSON.parse($('input.item-images-json').val());
				var curImageIdx = 1,
					total = images.length;
				var wrapper = $('.imageviewer'),
					curSpan = wrapper.find('.current');
				var viewer = ImageViewer(wrapper.find('.image-container'));
			 
				/* display total count */
				wrapper.find('.total').html(total);
				
				wrapper.find('.next').click(function(){
					 curImageIdx++;
					if(curImageIdx > total) curImageIdx = 1;
					_this.get_imageviewer_image(images, curImageIdx, viewer, curSpan);
				});
			 
				wrapper.find('.prev').click(function(){
					 curImageIdx--;
					if(curImageIdx < 1) curImageIdx = total;
					_this.get_imageviewer_image(images, curImageIdx, viewer, curSpan);
				});
			 
				/* initially show image */
				_this.get_imageviewer_image(images, curImageIdx, viewer, curSpan);
			}
		}
	},
	
	User: function() {
		this.init = function() {
			this.create_account();
			this.update_account();
		}
		
		this.create_account = function(){
			$('.create-account').ajaxForm({
				beforeSerialize: function() {
					wave_box('on');
				},
				success: function(response, textStatus, xhr, form) {
					if(response.status == 0){
						Lobibox.notify('error', {msg: response.message, size: 'mini', sound: false});
					}
					
					if(response.status == 1){
						window.location.href = '/user/account';
					}
					
					wave_box('off');
				}
            });
		}
		
		this.update_account = function(){
			$('.update-account').ajaxForm({
				beforeSerialize: function() {
					update_ckeditor_instances();
					wave_box('on');
				},
				success: function(response, textStatus, xhr, form) {
					if(response.status == 0){
						Lobibox.notify('error', {msg: response.message, size: 'mini', sound: false});
					}
					
					if(response.status == 1){
						Lobibox.notify('success', {msg: response.message, size: 'mini', sound: false});
					}
					
					wave_box('off');
				}
            });
		}
		
	},
	
	/**
     * Global
     */
    Global: function () {
		
		/**
		 * This method contains the list of functions that needs to be loaded
		 * when the "Global" object is instantiated.
		 *
		 */
		this.init = function() {
			this.set_ckeditor();
			this.set_datepicker();
		}
		
		/**
		 * Load CKEditor plugin
		 */
		this.set_ckeditor = function() {
			if($('#ck-editor-area').length){
				load_ckeditor('ck-editor-area', 300);
			}
		}
		
		/**
		 * Load CKEditor plugin
		 */
		this.set_datepicker = function() {
			if('.datepicker'){
				$('.datepicker').datetimepicker({
                    format: 'YYYY-MM-DD HH:mm:ss'
                });
			}
		}
	}
}

/**
 * When the document has been loaded...
 *
 */
jQuery(document).ready( function () {
		
	global = new app.Global(); /* Instantiate the Global Class */
	global.init(); /* Load Global class methods */
	
	posts = new app.Posts(); /* Instantiate the Posts Class */
	posts.init(); /* Load Posts class methods */
	
	user = new app.User(); /* Instantiate the User Class */
	user.init(); /* Load User class methods */
	
	/* Update item data via real time */
	socket.on('message', function(data) {
		var data = data.message;
		var item_id = '.item-' + data.id;
		for (var key in data) {
			if (data.hasOwnProperty(key)) {
				if(key == 'featured'){
					$(item_id + ' .item-featured').attr('src', '/images/uploads/' + data[key]);
				} else if(key == 'price') {
					$(item_id + ' .item-price').html(parseFloat(data[key]).toFixed(2));
				} else {
					$(item_id + ' .item-' + key).html(data[key]);
				}
			}
		}
	});
	
});