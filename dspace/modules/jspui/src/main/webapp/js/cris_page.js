jQuery(document).ready(function cris_dropdown(){
    jQuery("[role='menu'] a").click(function(e){
      e.preventDefault(); 
      a=jQuery(this).attr('href');
      jQuery.get( a, function( data ) {
         jQuery( "#dspaceitems" ).html( jQuery(data).find( "#dspaceitems" ).children() );
         cris_dropdown();
      });
    });
});


jQuery(document).ready(function cris_page(){
    jQuery(".pagination").click(function(e){
      e.preventDefault(); 
      a=jQuery(this).attr('href');
      jQuery.get( a, function( data ) {
         jQuery( "#dspaceitems" ).html( jQuery(data).find( "#dspaceitems" ).children() );
         cris_page();
      });
    });
});

var url=jQuery('.next').attr('href');
url=url.replace(url.match( /\?\S*/), "");
var pre=jQuery('.previous');
pre=pre.attr('href', url+pre.attr('href'));
