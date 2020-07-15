class CastVote
{
  constructor(options){
    this.$main = options.main;
  }

  init(){
    this.$main.each((i,element) => element.addEventListener('click',(event) => {
      $(event.target).toggleClass("text-success");
      this.magic(event.target.parentElement.href);
      event.target.preventDefault();
    } ))
  }

  magic(voteUrl)
  {
    $.ajax({
      url: voteUrl,
      type: "post",
      beforeSend: () => {
        $.LoadingOverlay("show");
      },
      success: (data) => {
        // console.log('data :>> ', data);

      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.vote-answer > a, .vote-comment > a')
    // main: $('.vote-answer > form > button, .vote-comment > a')
    // switch to button_to instead of link_to
  }

  let vote = new CastVote(options);
  // vote.init();
});
