// this script loops through the headers on the page and creates a table of contents

"use strict";
var ToC =
  '<nav role="navigation" class="table-of-contents">' + 
    '<ul>';

var newLine, id, el, title, link;

var link_counter = 0;
$( '.toc-content h2' ).each(function() {
  link_counter += 1;
  el = $(this);
  title = el.text();
  id = el.attr( 'id' ).replace('-title','')
  link = '#' + id;

  if(link_counter>1){
    el.append( '<a class="back-to-top" href="#title">To top</a>' );
  }

  newLine =
      '<h2>' +
        '<a href="' + link + '" class="toc-link">' +
          title +
        '</a>' +
      '</h2>';

  if (h3toc) {
    // Add h3 headers to toc
    $( '#' + id + ' h3' ).each(
      function() {
        el = $(this);
        title = el.text();
        id = el.attr( 'id' ).replace('-title','')
        link = '#' + id ;

        if(link_counter>1){
          el.append( '<a class="back-to-top" href="#title">To top</a>' );
        }

        newLine +=
            '<h3>' +
              '<a href="' + link + '" class="toc-link">' +
                title +
              '</a>' +
            '</h3>';

        if (h4toc) {
          // Add h4 headers to toc

          $('#' + id + ' h4').each(
            function() {
              el = $(this);
              title = el.text();
              id = el.attr( 'id' ).replace('-title','')
              link = '#' + el.attr('id');

              newLine +=
              '<h4>' +
                '<a href="' + link + '" class="toc-link h4links">' +
                  title +
                '</a>' +
              '</h4>';
            }
          );
        }
      }
    );
  }

  ToC += newLine;

});

ToC +=
   '</ul>' +
  '</nav>';