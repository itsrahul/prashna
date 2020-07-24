class CommentUpdater
{
  constructor(options)
  {
    this.$main = options.main;
    this.$question_main = options.question_main;
    this.$form = options.form;
    this.$text = options.form.find('input[type=text]');
    this.$button = options.form.find('input[type=submit]');
    this.$question_text = options.question_form.find('input[type=text]');
    this.$question_button = options.question_form.find('.submit-comment-button');
  }

  init()
  {
    this.$button.each((i,element) => element.addEventListener('click',(event) => {
      this.magic(this.$text[i].value,  this.$button[i].form.action, i, false);
      event.preventDefault();
    } ))
    this.$question_button.each((i,element) => element.addEventListener('click',(event) => {
      this.magic(this.$question_text[i].value,  this.$question_button[i].form.action, i, true);
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
          this.$question_main[index].innerHTML = data
        }
        else
        {
          this.$main[index].innerHTML = data
        }
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
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
