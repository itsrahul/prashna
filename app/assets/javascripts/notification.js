class NotificationReadAt
{
  constructor(options)
  {
    this.$main = options.main;
  }

  init()
  {
    this.$main.one("click", ".notification-item",(event) => {
      // window.alert('hello :>> ');
      debugger
      event.preventDefault();
    })

  }
  magic(content_val, answerUrl, index)
  {
    $.ajax({
      url: answerUrl,
      type: "post",
      data: $.param({ content: content_val }),
      beforeSend: () => {
        $.LoadingOverlay("show");
      },
      success: (data) => {
        this.$main[index].innerHTML = data
      },
      complete: () => {
        $.LoadingOverlay("hide");
      },
    })
  }
}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.notification-dropdown')
  }

  let updater = new NotificationReadAt(options);
  updater.init();
});
