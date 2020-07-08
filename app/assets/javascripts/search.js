class SearchQuestions
{
  constructor(options)
  {
    this.$main = options.main;
    this.$form = options.form;
    this.$text = options.form.find('input[type=text]');
    this.$button = options.form.find('input[type=submit]');

  }

  init()
  {
    this.$button[0].addEventListener('click',(event) => {
      this.magic(this.$text[0].value,  this.$button[0].form.action);
      event.preventDefault();
    } )
  }

  magic(search_val, productUrl)
  {
    // FIXME_AB: add ajax loader
    $.ajax({
      url: productUrl,
      type: "get",
      data: $.param({ search: search_val }),
      success: (data) => {
        if (data){
          this.$main[0].innerHTML = data
        }
        else{
          this.$main[0].innerHTML = `<h3>No questions found</h3>`
        }
      }
    })
  }
}

$(document).on('turbolinks:load', function() {
  let options = {
    main: $('.questions-list'),
    form: $('.search-button')
  }

  let updater = new SearchQuestions(options);
  updater.init();
});
