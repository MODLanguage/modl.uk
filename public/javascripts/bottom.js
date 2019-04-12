function copyTextToClipboard(text) {
  var textArea = document.createElement("textarea");
  // Place in top-left corner of screen regardless of scroll position.
  textArea.style.position = 'fixed';
  textArea.style.top = 0;
  textArea.style.left = 0;

  // Ensure it has a small width and height. Setting to 1px / 1em
  // doesn't work as this gives a negative w/h on some browsers.
  textArea.style.width = '2em';
  textArea.style.height = '2em';

  // We don't need padding, reducing the size if it does flash render.
  textArea.style.padding = 0;

  // Clean up any borders.
  textArea.style.border = 'none';
  textArea.style.outline = 'none';
  textArea.style.boxShadow = 'none';

  // Avoid flash of white box if rendered for any reason.
  textArea.style.background = 'transparent';


  textArea.value = text;

  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();

  try {
    var successful = document.execCommand('copy');
    var msg = successful ? 'successful' : 'unsuccessful';
    console.log('Copying text command was ' + msg);
  } catch (err) {
    console.log('Oops, unable to copy');
  }
  document.body.removeChild(textArea);
}  

$(document).ready(
  function() {
    var navOffset = 0;
    var shiftWindow = function() { 
      if ($(window).width() < 600) {
        navOffset = -50;
      }
      else {
        navOffset = -28
      }
      scrollBy(0, navOffset);
    };
    window.addEventListener("hashchange", shiftWindow);
    var stickyNavTop = $('#nm-navbar').offset().top;
     
    var stickyNav = function(){
      var scrollTop = $(window).scrollTop();
            
      if (scrollTop > stickyNavTop) { 
        $('#nm-navbar').addClass('sticky');
        $('#nm-navbar-holding').show();
        $('#navbar-logo').fadeIn()
      } else {
        $('#nm-navbar').removeClass('sticky'); 
        $('#nm-navbar-holding').hide();
        $('#navbar-logo').fadeOut()
      }
    };
     
    stickyNav();
     
    $(window).scroll(
      function() {
        stickyNav();
      }
    );

    $(".menu").click(function() {
      $("#navholder").slideToggle();
    })
    $("#content").click(function() {
      $("#navholder").slideUp();
    })
    if(window.location.hash) {
      shiftWindow();
    }
    $("#machine-diagrams-image").click(function() {
      location.href='/images/machine-diagrams.png'
    })

    $( '.platform-choice > ul > li' ).click(
      function() {
        var thisId = $(this).attr( 'id' );
        var which = $(this).data( 'which' );
        var divName = thisId.replace( '-' + which, '' );

        if ( which == 'win' ) {
          $( '.unix').removeClass( 'selected' );
          $( '.win').addClass( 'selected' );
          $( '.unix-code' ).hide();
          $( '.win-code' ).show();
        }
        else if( which == 'unix' ) {
          $( '.win').removeClass( 'selected' );
          $( '.unix').addClass( 'selected' );
          $( '.unix-code' ).show();
          $( '.win-code' ).hide();
        }
      }
    );
    $( '.language-choice > ul > li' ).click(
      function() {
        var thisId = $(this).attr( 'id' );
        var which = $(this).data( 'which' );
        var divName = thisId.replace( '-' + which, '' );

        if ( which == 'modl' ) {
          $( '#' + divName + '-json').removeClass( 'selected' );
          $( '#' + divName + '-yaml').removeClass( 'selected' );
          $( '#' + divName + '-modl').addClass( 'selected' );
          $( '#' + divName + '-json-code' ).hide();
          $( '#' + divName + '-yaml-code' ).hide();
          $( '#' + divName + '-modl-code' ).show();
        }
        else if( which == 'json' ) {
          $( '#' + divName + '-yaml').removeClass( 'selected' );
          $( '#' + divName + '-modl').removeClass( 'selected' );
          $( '#' + divName + '-json').addClass( 'selected' );
          $( '#' + divName + '-yaml-code' ).hide();
          $( '#' + divName + '-modl-code' ).hide();
          $( '#' + divName + '-json-code' ).show();
        }
        else if( which == 'yaml' ) {
          $( '#' + divName + '-modl').removeClass( 'selected' );
          $( '#' + divName + '-json').removeClass( 'selected' );
          $( '#' + divName + '-yaml').addClass( 'selected' );
          $( '#' + divName + '-modl-code' ).hide();
          $( '#' + divName + '-json-code' ).hide();
          $( '#' + divName + '-yaml-code' ).show();
        }        
      }      
    );
    $( '.copy-code' ).click(
      function() {
        code_id = $(this).data('code');
        code = $('#' + code_id).text();
        copyTextToClipboard(code);
      }
    );
    $( '.run-code' ).click(
      function() {
        code_id = $(this).data('code');
        code = $('#' + code_id).text();
        sendToPlayground('mini',code);
      }
    );    
  }
);