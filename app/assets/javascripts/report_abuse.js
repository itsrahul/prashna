class ReportAbuse
{
  constructor(options){
    this.$main = options.main;
    this.result = options.result;
    this.$buttons = options.main.find('input');
    this.$inputs = options.main.find('textarea');
  }

  init(){
    this.$buttons.each((i,element) => element.addEventListener('click',(event) => {
      let resultDiv = $(this.$main[i]).find(this.result)
      this.magic(this.$inputs[i].value, resultDiv, element.form.action, i);
      event.preventDefault();})
    )
  }

  magic(reasonVal, resultDiv ,reportAbuseUrl, index)
  {
    $.ajax({
      url: reportAbuseUrl,
      type: "get",
      data: { reason: reasonVal},
      success: (data) => {
        if (data.success)
        {
          resultDiv[0].innerHTML = `<div class="alert alert-primary" role="alert"> ${data.success} </div>`
          this.$inputs[index].value = '';
        }
        else
        {
          resultDiv[0].innerHTML = `<div class="alert alert-warning" role="alert"> ${data.failure} </div>`
        }
      },
    })
  }

}

document.addEventListener('turbolinks:load', function() {
  let options = {
    main: $('.modalReportAbuse'),
    result: '.report-abuse-result',
  }

  let report = new ReportAbuse(options);
  report.init();
});
