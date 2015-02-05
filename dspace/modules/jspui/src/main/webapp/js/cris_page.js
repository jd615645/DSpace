var href;

jQuery(document).ready(function cris_dropdown(){
  jQuery("[role='menu'] a").click(function(e){
    e.preventDefault(); 
    href=a=jQuery(this).attr('href');
    jQuery.get( a, function( data ) {
       jQuery( "#dspaceitems" ).html( jQuery(data).find( "#dspaceitems" ).children() );
      cris_dropdown();
    });
  });
});


jQuery(document).ready(function cris_page(){
  var url=jQuery('.pagination').eq(1).attr('href');
  if(typeof(url)!='undefined') url=url.replace(url.match( /\?\S*/), "");
  var pre=jQuery('.previous');
  pre=pre.attr('href', url+pre.attr('href'));

  jQuery(".pagination").click(function(e){
    e.preventDefault(); 
    href=a=jQuery(this).attr('href');
    var id=jQuery(this).parents("[role='tabpanel']");
    if(id.children('div').length<2) id=id.children('div').attr('id');
    else id=id.attr('id');
    console.log(id);
    jQuery.get( a, function( data ) {
      //if(jQuery(data).find( "#"+id ).css('display')=='none') id=jQuery(this).parents("[role='tabpanel']").find('div').attr('id');
      jQuery( "#"+id ).html( jQuery(data).find( "#"+id ) );
      cris_page();
    });
  });
});
