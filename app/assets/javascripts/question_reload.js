class FetchQuestions
{
  constructor(options)
  {
    this.$main = options.main;
    this.url = this.$main.data("path");
    this.redirctToUrl = this.$main.data("redirect-path");
    this.interval = options.interval;
  }

  init()
  {
    let time = new Date().toISOString(); 
    setInterval( () => {
      this.magic(time);
      time = new Date().toISOString();
    }, this.interval);
  }
  magic(time)
  {
    $.ajax({
      type: "GET",
      url: this.url,
      data: $.param({ time: time }),
      success: (data) => this.setToast(data)
    });
  }
  setToast(data)
  {
    if (data.count < 1) {
      return
    }
    this.$main.find('.toast-header strong').text('Prashna');
    this.$main.find('.toast-body').html(`<a href='${this.redirctToUrl}'>${data.count} new questions published.</a> `);
    this.$main.toast('show');
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.question-toast'),
    interval: 10000,
  }

  let refresh = new FetchQuestions(options);
  refresh.init();
});
