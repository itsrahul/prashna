class AnswerUpdater
{
  constructor(options)
  {
    this.$main = options.main;
    this.$form = options.form;
    this.$text = options.form.find('textarea');
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
        this.setResult(data, index);
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }

  setResult(data, index)
  {
    let $resultDiv = $(`.${this.$form[index].dataset["result"]}`);

    if (data.errors)
    {
      $resultDiv[0].innerHTML = `<div class="alert alert-warning" role="alert"> ${data.errors} </div>`
    }
    else
    {
      this.$main[index].innerHTML = data
      this.$text[index].value = '';
      $resultDiv[0].innerHTML = `<div class="alert alert-success" role="alert"> Answer posted successfully. </div>`
    }

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
