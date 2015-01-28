jQuery(function($) {
    var open = false;
    $('.footerSlideButton').click(function () {
        if(open === false) {
            $('#footerSlideContent').animate({ height: '200px' });
            $(this).css('backgroundPosition', 'bottom left');
            open = true;
        } else {
            $('#footerSlideContent').animate({ height: '0px' });
            $(this).css('backgroundPosition', 'top left');
            open = false;
        }
    });     
});
