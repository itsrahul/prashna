class FollowUser
{
  constructor(options){
    this.$main = options.main;
    this.fetchUrl = options.main.data("fetch");
    this.images = [ options.paths.data("follow-image-url"), options.paths.data("following-image-url") ];
    // this.follow = this.images[0];
    // this.following = this.images[1];
  }

  init(){
    this.magicOnce(this.$main[0], this.fetchUrl, 1, this.images );
    // debugger
    this.$main.each((_i,element) => element.addEventListener('click',(event) => {
      if (parseInt(event.target.dataset["status"]) ) 
      {
        // current status: 1 i.e. followed, action: unfollow
        this.magic(event.target, (event.target.dataset["status"] = 0), this.images );
      }
      else
      {
        // current status: 0 i.e. not followed, action: follow
        this.magic(event.target, (event.target.dataset["status"] = 1), this.images );
      }
      event.preventDefault();
    } ))
  }

  magic(element, state, images)
  { 
    $.ajax({
      url: element.parentElement.action,
      type: "post",
      data: { state: state },
      success: (data) => {
        // $(`.${element.dataset["id"]}`)[0].textContent = `(${data.follower_count})`
        element.src = images[state];
      },
    })
  }

  magicOnce(element, url, state, images)
  { 
    $.ajax({
      url: url,
      type: "post",
      data: { state: state },
      success: (data) => {
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
    paths: $('.follow-user-paths'),
    // images: ["/assets/follow.png", "/assets/following.png"],
  }
  let vote = new FollowUser(options);
  vote.init();
});
