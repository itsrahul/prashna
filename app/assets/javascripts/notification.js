class SetNotifications
{
  constructor(options)
  {
    this.$main = options.main;
    this.$counter = options.counter;
    this.interval = options.interval;
    this.url = this.$main.data("path");
    this.notificationUrl = this.$main.data("notification-path");
    this.clearIntervalCount = options.clearInterval;
  }

  init()
  {
    // #TODO: fetch notification count.
    const myVar = setInterval( () => {
      this.magic();
      if (this.clearIntervalCount > 1)
      {
        this.clearIntervalCount--;
      }
      else
      {
        clearInterval(myVar);
      }
    }, this.interval);
  }
  magic()
  {
    $.ajax({
      type: "GET",
      url: this.url,
      success: (response) => this.setItems(response)
    });
  }
  
  setItems(response)
  {
    this.$main[0].innerHTML = ""

    if (response.count > 0){
      this.$counter[0].textContent = response.count;
      response.items.forEach(element => {
        this.$main[0].innerHTML +=  `<a class='dropdown-item' href='${this.notificationUrl}.${element.id}'> ${element.message} </a>`
      });
    }
    else
    {
      this.$counter[0].textContent = "";
      this.$main[0].innerHTML +=  "<a class='dropdown-item' href='#'> No new notifications </a>"

    }
  }
}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.notification-dropdown'),
    counter: $('.notification-counter'),
    interval: 4000,
    clearInterval: 6,
  }

  let notify = new SetNotifications(options);
  notify.init();
});
