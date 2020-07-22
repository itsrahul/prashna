class FetchVoteOnLoad
{
  constructor(options){
    this.$main = options.main;
  }

  init(){
    this.$main.each((i,element) => {
      this.magic(element, element.dataset["id"], element.form.action);
    })
  }

  magic(element, id, voteUrl)
  {
    $.ajax({
      url: voteUrl,
      type: "get",
      success: (data) => {
        $(`.${id}-count`)[0].textContent = `(${data.upcount})`
        $(`.${id}-count`)[1].textContent = `(${data.downcount})`
        if (data.voted)
        {
          $(element).toggleClass("btn-success");
        }
      },
    })
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.vote-answer-buttons > form > input[type=submit], .vote-comment-buttons > form > input[type=submit]'),
  }

  let vote = new FetchVoteOnLoad(options);
  vote.init();
});
