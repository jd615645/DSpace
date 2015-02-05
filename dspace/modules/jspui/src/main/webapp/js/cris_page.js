//dropdown
function cris_dropdown(){
  jQuery("[role='menu'] a").click(function(e){
    e.preventDefault(); 
    a = jQuery(this).attr('href');
    jQuery.get( a, function( data ) {
       jQuery( "#dspaceitems" ).html( jQuery(data).find( "#dspaceitems" ).children() );
      all();
    });
  });
}


//page turning
function cris_page(){
  jQuery(".pagination").click(function(e){
    e.preventDefault(); 
    a = jQuery(this).attr('href');
    var id = jQuery(this).parents("[role='tabpanel']");
    if(id.children('div').length<2) id=id.children('div').attr('id');
    else id = id.attr('id');
    jQuery.get( a, function( data ) {
      jQuery( "#"+id ).html( jQuery(data).find( "#"+id ) );
      all();
    });
  });
}


//sorting
function cris_sort(){
  var url = jQuery("[role='tablist']").find('.active a').attr('href');
  if(typeof(jQuery("[role='tablist']").find('.active a').attr('href'))=='string')url=url.split('?')[0];
  var curId = jQuery("[role='tablist']").find('.active').attr('aria-controls');
  var sortItem = jQuery('#'+curId).find('.sortable');

  for(var i=0; i<sortItem.length; i++){
    var sort = sortItem.eq(i).find('a').attr('onclick').split('(')[1].split(')')[0].split(',');
    sortItem.eq(i).find('a').attr('href', url+"?"+sortBy(sort[0], sort[1].split('\'')[1]));
  }

  jQuery(".sortable a").click(function(e){
    e.preventDefault();
    a = jQuery(this).attr('href');
    var id = jQuery(this).parents("[role='tabpanel']");
    if(id.children('div').length<2) id=id.children('div').attr('id');
    else id = id.attr('id');
    jQuery.get( a, function( data ) {
      jQuery( "#"+id ).html( jQuery(data).find( "#"+id ) );
      all();
    });
  });
}


function all(){
  cris_dropdown();
  cris_page();
  cris_sort();
}
all();
