class FollowUser
{
  constructor(options){
    this.$main = options.main;
    this.fetchUrl = options.main.data("fetch");
    this.images = options.images;
    this.follow = options.images[0];
    this.following = options.images[1];
  }

  init(){
    this.magic(this.$main[0], this.fetchUrl, 1, this.images );
    debugger
    this.$main.each((_i,element) => element.addEventListener('click',(event) => {
      if (parseInt(event.target.dataset["status"]) ) 
      {
        // current status: 1 i.e. followed, action: unfollow
        // this.magic(event.target, (event.target.dataset["status"] = 0), this.images );
        this.magic(event.target, event.target.parentElement.action, (event.target.dataset["status"] = 0), this.images );
        // event.target.src = images[0];
      }
      else
      {
        // current status: 0 i.e. not followed, action: follow
        // this.magic(event.target, (event.target.dataset["status"] = 1), this.images );
        this.magic(event.target, event.target.parentElement.action, (event.target.dataset["status"] = 1), this.images );
        // event.target.src = images[1];
      }
      event.preventDefault();
    } ))
  }

  magic(element, url, state, images)
  { 
    $.ajax({
      url: url,
      type: "post",
      data: { state: state },
      success: (data) => {
        // $(`.${element.dataset["id"]}`)[0].textContent = `(${data.follower_count})`
        if (data)
        {
          element.src = images[state];
        }
      },
    })
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.follow-user'),
    images: ["/assets/follow.png", "/assets/following.png"],
  }
  let vote = new FollowUser(options);
  // vote.init();
});
