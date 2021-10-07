function postToIframe(data,url,target){
  $('body').append('<form action="'+url+'" method="post" target="'+target+'" id="postToIframe"></form>');
  $.each(data,function(n,v){
    $('#postToIframe').append('<textarea name="'+n+'">'+v+'</textarea>');
  });
  $('#postToIframe').submit().remove();
}

function playgroundSize(size){
  if(size=="big"){
    newWidth = 400;
    newHeight = 600;
    modlHeight = 200;
    jsonHeight = 260;
    $(".reduce").show();
    $(".enlarge").hide();
  }
  else if(size=="small"){
    newWidth = 300;
    newHeight = 400;
    modlHeight = 120;
    jsonHeight = 141;
    $(".reduce").hide();
    $(".enlarge").show();
  }
  $("#playground-window").width(newWidth);
  $("#playground-window").height(newHeight);
  $("#playground-iframe").contents().find("#modl").height(modlHeight);
  $("#playground-iframe").contents().find("#converted-object").height(jsonHeight);
}

function sendToPlayground(type,code){
  $("#playground-window").show();
  if(type=="mini"){
    url = "mini-playground";
    iframeTarget = "playground-iframe";
  }
  else{
    url = "playground";
    iframeTarget = "new"; 
  }
  postToIframe({modl:code},url,iframeTarget);
}

$(document).ready(
  function() {
    $( '#playground-window > .playground-title > .window-options > .full > a' ).click(
      function() {
        code = window.frames[0].document.getElementById('modl').value;
        sendToPlayground('new',code);
      }
    );

    $( '#playground-window > .playground-title > .window-options > .close > a' ).click(
      function() {
        $('#playground-window').hide()
      }
    );
  }
);