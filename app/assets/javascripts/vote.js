class CastVote
{
  constructor(options){
    this.$main = options.main;
  }

  init(){
    this.$main.each((i,element) => element.addEventListener('click',(event) => {
      $(event.target).toggleClass("text-success");
      // event.preventDefault();
    } ))
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.cast-vote > button > svg')
    // not doing anything
    // update class def for like/dislike
  }

  let vote = new CastVote(options);
  vote.init();
});
