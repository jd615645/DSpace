jQuery(document).ready(function facet(){
    jQuery('.facet .next').click(function(e){
      e.preventDefault(); 
      a=jQuery(this).attr('href');
      b=jQuery(this).parents('.facet').attr('id');
      jQuery.get( a, function( data ) {
         jQuery( "#"+b ).html( jQuery(data).find( "#"+b).children() );
         facet();
      });
    });

    jQuery('.facet .previous').click(function(e){
      e.preventDefault(); 
      a=jQuery(this).attr('href');
      b=jQuery(this).parents('.facet').attr('id');
      jQuery.get( a, function( data ) {
         jQuery( "#"+b ).html( jQuery(data).find( "#"+b).children() );
         facet();
      });
    });
});
