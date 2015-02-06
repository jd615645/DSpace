jQuery(document).ready(function(){
  //language
  var loc="?";
  var str=location.href.split("?");
  if(str.length>1){
      //loc=str[0].split("&")[0]+"?";
      str=str[1].split('&');
      for(var i=0; i<str.length; i++){
          if(str[i][str[i].length-1]=='#') str[i][str[i].length-1]='';
          if(!str[i].match('locale=') && str[i]!="")  loc+="&"+str[i];
      }
  }
  jQuery('#zh_TW').attr('href', loc+'&locale=zh_TW');
  jQuery('#en').attr('href', loc+'&locale=en');
});

//navbar type
var nav=function(){
    if(jQuery(window).width()<992){
        jQuery('header.navbar').removeClass('navbar-fixed-top');
        jQuery('body').css('padding-top', '0px');
    }else{
        jQuery('header.navbar').addClass('navbar-fixed-top');
        jQuery('body').css('padding-top', '65px');
    }
}
nav();
jQuery(document).ready(function(){
    jQuery(window).resize(function(){
        nav();
    });
});


//facets page turning
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

