class FilterSearchQuestions
{
  constructor(options)
  {
    this.$main = options.main;
    this.$form = options.form;
    this.$button = options.form.find('input[type=submit]');
    this.$topics = options.main.find('.filter-topics');

  }

  init()
  {
    this.$topics.each((_i,element) => element.addEventListener('click',(event) => {
      this.magic(element.text, element.href);
      event.preventDefault();
    } ))

  }

  magic(search_val, searchUrl)
  {
    $.ajax({
      url: searchUrl,
      type: "get",
      // data: $.param({ search: search_val }),
      beforeSend: () => {
        $.LoadingOverlay("show");
        this.$main[0].innerHTML = "";
      },
      success: (data) => {
        if (data){
          this.$main[0].innerHTML = data
        }
        else{
          this.$main[0].innerHTML = `<h3>No questions found</h3>`
        }
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }
}

$(document).on('turbolinks:load', function() {
  let options = {
    main: $('.questions-list'),
    form: $('.search-button')
  }

  let filter = new FilterSearchQuestions(options);
  filter.init();
});
