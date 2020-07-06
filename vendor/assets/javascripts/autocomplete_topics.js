class TopicAutocomplete{
  constructor($main){
    this.$main = $main;
  }

  init(){
    this.$main.val('');

    $( () => {
      function split( val ) {
        return val.split( /,\s*/ );
      }
      function extractLast( term ) {
        return split( term ).pop();
      }

      this.$main
        // don't navigate away from the field on tab when selecting an item
        .on( "keydown", function( event ) {
          if ( event.keyCode === $.ui.keyCode.TAB &&
              $( this ).autocomplete( "instance" ).menu.active ) {
            event.preventDefault();
          }
        })
        .autocomplete({
          source: function( request, response ) {
          
            $.ajax({
              dataType: "json",
              url: "topics",
              beforeSend: () => {
                $('#user_topic').LoadingOverlay("show")
              },
              data: {
                q: extractLast( request.term )
              },
              success: response,
              complete: () => {
                $('#user_topic').LoadingOverlay("hide", true)
              },
            });
          },
          search: function() {
            // custom minLength
            var term = extractLast( this.value );
            if ( term.length < 2 ) {
              return false;
            }
          },
          focus: function() {
            // prevent value inserted on focus
            return false;
          },
          select: function( event, ui ) {
            var terms = split( this.value );
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push( ui.item.value );
            // add placeholder to get the comma-and-space at the end
            terms.push( "" );
            this.value = terms.join( ", " );
            return false;
          }
        });
    } );
  }
}

document.addEventListener('turbolinks:load', function() {
  new TopicAutocomplete($('#user_topic')).init();
}); 