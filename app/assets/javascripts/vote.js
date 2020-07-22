class CastVote
{
  constructor(options){
    this.$main = options.main;
  }

  init(){
    this.$main.each((i,element) => element.addEventListener('click',(event) => {
      $(event.target).toggleClass("btn-success");
      this.magic(event.target.dataset["id"], event.target.form.action);
      event.preventDefault();
    } ))
  }

  magic(id, voteUrl)
  { 
    $.ajax({
      url: voteUrl,
      type: "post",
      beforeSend: () => {
        $.LoadingOverlay("show");
      },
      success: (data) => {
        $(`.${id}-count`)[0].textContent = `(${data.upcount})`
        $(`.${id}-count`)[1].textContent = `(${data.downcount})`
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.vote-answer-buttons > form > input[type=submit], .vote-comment-buttons > form > input[type=submit]'),
  }

  let vote = new CastVote(options);
  vote.init();
});
