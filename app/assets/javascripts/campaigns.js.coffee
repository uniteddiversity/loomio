$ ->
  $('#js-dismiss').click ->
    $('#js-banner').hide()
    $('.navbar-fixed-top').removeClass('js-campaign')
    $('.logged-in-navigation').removeClass('js-campaign')
    $('.main-container.container').css('padding-top', '40px')
