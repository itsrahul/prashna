class CommentUpdater
{
  constructor(options)
  {
    this.$main = options.main;
    this.$question_main = options.question_main;
    this.$form = options.form;
    this.$text = options.form.find('textarea');
    this.$button = options.form.find('input[type=submit]');
    this.$question_form = options.question_form;
    this.$question_text = options.question_form.find('textarea');
    this.$question_button = options.question_form.find('.submit-comment-button');
  }

  init()
  {
    this.$button.each((i,element) => element.addEventListener('click',(event) => {
      this.magic(this.$text[i].value,  this.$button[i].form.action, i, false);
      // this.$text[i].value = '';
      event.preventDefault();
    } ))
    this.$question_button.each((i,element) => element.addEventListener('click',(event) => {
      this.magic(this.$question_text[i].value,  this.$question_button[i].form.action, i, true);
      // this.$question_text[i].value = '';
      event.preventDefault();
    } ))
  }
  magic(content_val, commentUrl, index, question_comment)
  {
    $.ajax({
      url: commentUrl,
      type: "post",
      data: $.param({ content: content_val }),
      beforeSend: () => {
        $.LoadingOverlay("show");
      },
      success: (data) => {
        if (question_comment)
        {
          this.setResult(this.$question_form, this.$question_main, this.$question_text, data, index);
          // this.$question_main[index].innerHTML = data
        }
        else
        {
          this.setResult(this.$form, this.$main, this.$text, data, index);
          // this.$main[index].innerHTML = data
        }
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }

  setResult($form, $main, $text, data, index)
  {
    let $resultDiv = $(`.${$form[index].dataset["result"]}`);

    if (data.errors)
    {
      $resultDiv[0].innerHTML = `<div class="alert alert-warning rounded" role="alert"> ${data.errors} </div>`
    }
    else
    {
      $main[index].innerHTML = data
      $text[index].value = '';
      $resultDiv[0].innerHTML = `<div class="alert alert-success rounded" role="alert"> Comment posted successfully. </div>`
    }

  }
}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.answer-comment-list'),
    form: $('.answer-comment-div'),
    question_main: $('.question-comment-list'),
    question_form: $('.comment-div')
  }

  let updater = new CommentUpdater(options);
  updater.init();
});
