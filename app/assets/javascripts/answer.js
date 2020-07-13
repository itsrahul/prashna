class AnswerUpdater
{
  constructor(options)
  {
    this.$main = options.main;
    this.$form = options.form;
    this.$text = options.form.find('input[type=text]');
    this.$button = options.form.find('.submit-answer');

  }

  init()
  {
    this.$button.each((i,element) => element.addEventListener('click',(event) => {
      this.magic(this.$text[i].value,  this.$button[i].form.action, i);
      event.preventDefault();
    } ))

  }
  magic(content_val, answerUrl, index)
  {
    $.ajax({
      url: answerUrl,
      type: "post",
      data: $.param({ content: content_val }),
      beforeSend: () => {
        $.LoadingOverlay("show");
      },
      success: (data) => {
        this.$main[index].innerHTML = data
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }
}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.answer-list'),
    form: $('.answer-div')
  }

  let updater = new AnswerUpdater(options);
  updater.init();
});
