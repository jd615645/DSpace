//dropdown
j(function cris_dropdown(){
  j('#dspaceitems').on('click', "[role='menu'] a", function(e){
    e.preventDefault(); 
    a = j(this).attr('href');
    j.get( a, function( data ) {
       j( '#dspaceitems' ).html( j(data).find( '#dspaceitems' ).children() );
    });
  });
});


//page turning
j(function cris_page(){
  j('.pagination').parents("[role='tabpanel']").on('click', '.pagination', function(e){
    e.preventDefault(); 
    a = j(this).attr('href');
    var id = j(this).parents("[role='tabpanel']");
    if(id.children('div').length<2) id=id.children('div').attr('id');
    else id = id.attr('id');
    j.get( a, function( data ) {
      j( "#"+id ).html( j(data).find( "#"+id ) );
    });
  });
});


//sorting
j(function cris_sort(){
  j(".sortable a").parents("[role='tabpanel']").on('click', '.sortable a', function(e){
    e.preventDefault();
    var url = j("[role='tablist']").find('.active a').attr('href').split('#')[0].split('?')[0];
    var sort = j(this).attr('onclick').split('(')[1].split(')')[0].split(',');
    url = url + "?" + sortBy(sort[0], sort[1].split('\'')[1]);
    console.log(url);

    var id = j(this).parents("[role='tabpanel']");
    if(id.children('div').length<2) id=id.children('div').attr('id');
    else id = id.attr('id');
    j.get(url, function(data){
      j( "#"+id ).html( j(data).find( "#"+id ) );
    });
  });
});
