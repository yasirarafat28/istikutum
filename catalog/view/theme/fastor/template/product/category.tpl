<?php echo $header; 
if(isset($mfilter_json)) {
	if(!empty($mfilter_json)) { 
		echo '<div id="mfilter-json" style="display:none">' . base64_encode( $mfilter_json ) . '</div>'; 
	} 
}

$theme_options = $registry->get('theme_options');
$config = $registry->get('config'); 
$background_status = false;
include('catalog/view/theme/'.$config->get($config->get('config_theme') . '_directory').'/template/new_elements/wrapper_top.tpl'); ?>
<div id="mfilter-content-container">
  <?php if ($thumb || $description) { ?>
  <div class="category-info clearfix">
    <?php if ($thumb) { ?>
    <div class="image"><img src="<?php echo $thumb; ?>" alt="<?php echo $heading_title; ?>" /></div>
    <?php } ?>
    <?php if ($description) { ?>
    <?php echo $description; ?>
    <?php } ?>
  </div>
  <?php } ?>
  <?php if ($categories && $theme_options->get('refine_search_style') != '2') { ?>
  <div class="refine_search_overflow text-center"><h2 class="refine_search"><?php echo $text_refine; ?></h2></div>
  <div class="category-list<?php if ($theme_options->get('refine_search_style') == '1') { echo ' category-list-text-only'; } ?>">
  	<div class="row">
  	  <?php 
  	  $class = 3; 
  	  $row = 4; 
  	  
  	  if($theme_options->get( 'refine_search_number' ) == 2) { $class = 62; }
  	  if($theme_options->get( 'refine_search_number' ) == 5) { $class = 25; }
  	  if($theme_options->get( 'refine_search_number' ) == 3) { $class = 4; }
  	  if($theme_options->get( 'refine_search_number' ) == 6) { $class = 2; }
  	  
  	  if($theme_options->get( 'refine_search_number' ) > 1) { $row = $theme_options->get( 'refine_search_number' ); } 
  	  ?>
	  <?php $row_fluid = 0; foreach ($theme_options->refineSearch() as $category) { $row_fluid++; ?>
	  	<?php 
	  	if ($theme_options->get('refine_search_style') != '1') {
	  		$width = 250;
	  		$height = 250;
	  		if($theme_options->get( 'refine_image_width' ) > 20) $width = $theme_options->get( 'refine_image_width' );
	  		if($theme_options->get( 'refine_image_height' ) > 20) $height = $theme_options->get( 'refine_image_height' );
	  		$model_tool_image = $registry->get('model_tool_image');
		  	if($category['thumb'] != '') { 
		  		$image = $model_tool_image->resize($category['thumb'], $width, $height); 
		  	} else { 
		  		$image = $model_tool_image->resize('no_image.jpg', $width, $height); 
		  	} 
	  	}
	  	?>
	  	<?php $r=$row_fluid-floor($row_fluid/$row)*$row; if($row_fluid>$row && $r == 1) { echo '</div><div class="row">'; } ?>
	  	<div class="col-sm-<?php echo $class; ?> col-xs-6">
	  		<?php if ($theme_options->get('refine_search_style') != '1') { ?>
		  	<a href="<?php echo $category['href']; ?>"><img src="<?php echo $image; ?>" alt="<?php echo $category['name']; ?>" /></a>
		  	<?php } ?>
		  	<a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
	  	</div>
	  <?php } ?>
	</div>
  </div>
  <?php } ?>
  <?php if ($products) { ?>
  <?php $currently = false; ?>
  <?php if(isset($_COOKIE['display'])) {
  	$currently = $_COOKIE['display'];
  } else {
  	if($theme_options->get('default_list_grid') == '1') { 
  		$currently = 'grid'; 
  	} else { 
  		$currently = 'list'; 
  	}
  } ?>
  
  <!-- Filter -->
  <div class="product-filter clearfix">
	<div class="options">
		<div class="product-compare"><a href="<?php echo $compare; ?>" id="compare-total"><?php echo $text_compare; ?></a></div>
		
		<div class="button-group display" data-toggle="buttons-radio">
			<button id="grid" <?php if($currently == 'grid') { echo 'class="active"'; } ?> rel="tooltip" title="Grid" onclick="display('grid');"><i class="fa fa-th-large"></i></button>
			<button id="list" <?php if($currently != 'grid') { echo 'class="active"'; } ?> rel="tooltip" title="List" onclick="display('list');"><i class="fa fa-th-list"></i></button>
		</div>
	</div>
  	
  	<div class="list-options">
  		<div class="sort">
  			<select onchange="location = this.value;">
  			  <?php foreach ($sorts as $sorts) { ?>
  			  <?php if ($sorts['value'] == $sort . '-' . $order) { ?>
  			  <option value="<?php echo $sorts['href']; ?>" selected="selected"><?php echo $sorts['text']; ?></option>
  			  <?php } else { ?>
  			  <option value="<?php echo $sorts['href']; ?>"><?php echo $sorts['text']; ?></option>
  			  <?php } ?>
  			  <?php } ?>
  			</select>
  		</div>
  		
  		<div class="limit">
  			<select onchange="location = this.value;">
  			  <?php foreach ($limits as $limits) { ?>
  			  <?php if ($limits['value'] == $limit) { ?>
  			  <option value="<?php echo $limits['href']; ?>" selected="selected"><?php echo $limits['text']; ?></option>
  			  <?php } else { ?>
  			  <option value="<?php echo $limits['href']; ?>"><?php echo $limits['text']; ?></option>
  			  <?php } ?>
  			  <?php } ?>
  			</select>
  		</div>
  	</div>
  </div>
  
<?php if($currently != 'grid') { ?>
<!-- Products list -->
<div class="product-list active">
	<?php foreach ($products as $product) { ?>
	<!-- Product -->
	<div>
		<div class="row">
			<div class="image col-sm-3">
				<?php if($product['special'] && $theme_options->get( 'display_text_sale' ) != '0') { ?>
					<?php $text_sale = 'Sale';
					if($theme_options->get( 'sale_text', $config->get( 'config_language_id' ) ) != '') {
						$text_sale = $theme_options->get( 'sale_text', $config->get( 'config_language_id' ) );
					} ?>
					<?php if($theme_options->get( 'type_sale' ) == '1') { ?>
					<?php $product_detail = $theme_options->getDataProduct( $product['product_id'] );
					$roznica_ceny = $product_detail['price']-$product_detail['special'];
					$procent = ($roznica_ceny*100)/$product_detail['price']; ?>
					<div class="sale">-<?php echo round($procent); ?>%</div>
					<?php } else { ?>
					<div class="sale"><?php echo $text_sale; ?></div>
					<?php } ?>
				<?php } elseif($theme_options->get( 'display_text_new' ) != '0' && $theme_options->isLatestProduct( $product['product_id'] )) { ?>
					 <div class="new"><?php if($theme_options->get( 'new_text', $config->get( 'config_language_id' ) ) != '') { echo $theme_options->get( 'new_text', $config->get( 'config_language_id' ) ); } else { echo 'New'; } ?></div>
				<?php } ?>
				
				<?php if($product['thumb']) { ?>
					<?php if($theme_options->get( 'lazy_loading_images' ) != '0') { ?>
					<a href="<?php echo $product['href']; ?>"><img src="image/catalog/blank.gif" data-echo="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" /></a>
					<?php } else { ?>
					<a href="<?php echo $product['href']; ?>"><img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" /></a>
					<?php } ?>
				<?php } else { ?>
				<a href="<?php echo $product['href']; ?>"><img src="image/no_image.jpg" alt="<?php echo $product['name']; ?>" /></a>
				<?php } ?>
				
				<?php if($theme_options->get( 'display_specials_countdown' ) == '1' && $product['special']) { $countdown = rand(0, 5000)*rand(0, 5000); 
				          $product_detail = $theme_options->getDataProduct( $product['product_id'] );
				          $date_end = $product_detail['date_end'];
				          if($date_end != '0000-00-00' && $date_end) { ?>
				     		<script>
				     		$(function () {
				     			var austDay = new Date();
				     			austDay = new Date(<?php echo date("Y", strtotime($date_end)); ?>, <?php echo date("m", strtotime($date_end)); ?> - 1, <?php echo date("d", strtotime($date_end)); ?>);
				     			$('#countdown<?php echo $countdown; ?>').countdown({until: austDay});
				     		});
				     		</script>
				     		<div id="countdown<?php echo $countdown; ?>" class="clearfix"></div>
					     <?php } ?>
				<?php } ?>
			</div>
			
			<div class="name-actions col-sm-4">
			     <div class="name"><a href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a></div>
			     <?php if($theme_options->get( 'product_list_type' ) == '4') { ?>
			     <?php $product_detail = $theme_options->getDataProduct( $product['product_id'] ); ?>
			     <div class="brand"><?php echo $product_detail['manufacturer']; ?></div>
			     <?php } ?>
			     
			     <?php if($product['price']) { ?>
				<div class="price">
					<?php if (!$product['special']) { ?>
					<?php echo $product['price']; ?>
					<?php } else { ?>
					<span class="price-old"><?php echo $product['price']; ?></span> <span class="price-new"><?php echo $product['special']; ?></span>
					<?php } ?>
				</div>
				<?php } ?>
				
				<ul>
				     <?php if($theme_options->get( 'display_add_to_cart' ) != '0') { ?>
				          <?php $enquiry = false; if($config->get( 'product_blocks_module' ) != '') { $enquiry = $theme_options->productIsEnquiry($product['product_id']); }
				          if(is_array($enquiry)) { ?>
				          <li><a href="javascript:openPopup('<?php echo $enquiry['popup_module']; ?>', '<?php echo $product['product_id']; ?>')" data-toggle="tooltip" data-original-title="<?php echo $enquiry['block_name']; ?>"><i class="fa fa-question"></i></a></li>
				          <?php } else { ?>
				          <li><a onclick="cart.add('<?php echo $product['product_id']; ?>');" data-toggle="tooltip" data-original-title="<?php echo $button_cart; ?>"><i class="fa fa-shopping-cart"></i></a></li>
				          <?php } ?>
				     <?php } ?>
				     
				     <?php if($theme_options->get( 'quick_view' ) == 1) { ?>
				     <li class="quickview"><a href="index.php?route=product/quickview&amp;product_id=<?php echo $product['product_id']; ?>" data-toggle="tooltip" data-original-title="<?php if($theme_options->get( 'quickview_text', $config->get( 'config_language_id' ) ) != '') { echo html_entity_decode($theme_options->get( 'quickview_text', $config->get( 'config_language_id' ) )); } else { echo 'Quickview'; } ?>"><i class="fa fa-search"></i></a></li>
				     <?php } ?>
				
					<?php if($theme_options->get( 'display_add_to_compare' ) != '0') { ?>
					<li><a onclick="compare.add('<?php echo $product['product_id']; ?>');" data-toggle="tooltip" data-original-title="<?php if($theme_options->get( 'add_to_compare_text', $config->get( 'config_language_id' ) ) != '') { echo $theme_options->get( 'add_to_compare_text', $config->get( 'config_language_id' ) ); } else { echo 'Add to compare'; } ?>"><i class="fa fa-exchange"></i></a></li>
					<?php } ?>
					
					<?php if($theme_options->get( 'display_add_to_wishlist' ) != '0') { ?>
					<li><a onclick="wishlist.add('<?php echo $product['product_id']; ?>');" data-toggle="tooltip" data-original-title="<?php if($theme_options->get( 'add_to_wishlist_text', $config->get( 'config_language_id' ) ) != '') { echo $theme_options->get( 'add_to_wishlist_text', $config->get( 'config_language_id' ) ); } else { echo 'Add to wishlist'; } ?>"><i class="fa fa-heart"></i></a></li>
					<?php } ?>
				</ul>
			</div>
			
			<div class="desc col-sm-5">
				<div class="description"><?php echo $product['description']; ?></div>
			</div>
		</div>
	</div>
	<?php } ?>
</div>
<?php } ?>

<?php if($currently == 'grid') { ?>
<!-- Products grid -->
<?php 
$class = 3; 
$row = 4; 

if($theme_options->get( 'product_per_pow2' ) == 6) { $class = 2; }
if($theme_options->get( 'product_per_pow2' ) == 5) { $class = 25; }
if($theme_options->get( 'product_per_pow2' ) == 3) { $class = 4; }

if($theme_options->get( 'product_per_pow2' ) > 1) { $row = $theme_options->get( 'product_per_pow2' ); } 
?>
<div class="product-grid active">
	<div class="row">
	  	<?php $row_fluid = 0; foreach ($products as $product) { $row_fluid++; ?>
		  	<?php $r=$row_fluid-floor($row_fluid/$row)*$row; if($row_fluid>$row && $r == 1) { echo '</div><div class="row">'; } ?>
		  	<div class="col-sm-<?php echo $class; ?> col-xs-6">
		  	    <?php include('catalog/view/theme/'.$config->get($config->get('config_theme') . '_directory').'/template/new_elements/product.tpl'); ?>
		  	</div>
	    <?php } ?>
  </div>
</div>
<?php } ?>
  
  <div class="row pagination-results">
    <div class="col-sm-6 text-left"><?php echo $pagination; ?></div>
    <div class="col-sm-6 text-right"><?php echo $results; ?></div>
  </div>
  <?php } ?>
  <?php if (!$categories && !$products) { ?>
  <p style="padding-top: 30px"><?php echo $text_empty; ?></p>
  <div class="buttons">
    <div class="pull-right"><a href="<?php echo $continue; ?>" class="btn btn-primary"><?php echo $button_continue; ?></a></div>
  </div>
  <?php } ?>
<script type="text/javascript"><!--
function setCookie(key, value) {
    var expires = new Date();
    expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
    document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

function display(view) {
	if (view == 'list') {
		setCookie('display','list');
		location.reload();
	} else {
		setCookie('display','grid');
		location.reload();
	}
}
//--></script> 
</div>
<?php include('catalog/view/theme/'.$config->get($config->get('config_theme') . '_directory').'/template/new_elements/wrapper_bottom.tpl'); ?>
<?php echo $footer; ?>