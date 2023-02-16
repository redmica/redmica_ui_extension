function renderTimelogChart(canvas_id, title, chart_data){
  var backgroundColors = ['rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(255, 159, 64, 0.2)'];
  var borderColors = ['rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)', 'rgba(255, 159, 64, 1)'];
  chart_data.datasets[0].backgroundColor = [];
  chart_data.datasets[0].borderColor = [];
  chart_data.datasets[0].borderWidth = [];
  if (chart_data.type=='bar') {
    for (var i = 0; i < chart_data.datasets[0].data.length; i++) {
      chart_data.datasets[0].backgroundColor[i] = backgroundColors[i % backgroundColors.length];
      chart_data.datasets[0].borderColor[i] = borderColors[i % backgroundColors.length];
      chart_data.datasets[0].borderWidth[i] = 1;
    }
  } else if (chart_data.type=='horizontalBar') {
    for (var i = 0; i < chart_data.datasets.length; i++) {
      chart_data.datasets[i].backgroundColor = backgroundColors[i % backgroundColors.length];
      chart_data.datasets[i].borderColor = borderColors[i % backgroundColors.length];
      chart_data.datasets[i].borderWidth = 1;
    }
  }
  if (chart_data.type=='horizontalBar') {
    var ctx = $(canvas_id);
    if (chart_data.labels.length > 40) {
      ctx.attr('height', chart_data.labels.length * 5);
    } else {
      ctx.attr('height', 20 + chart_data.labels.length * 20);
    }
  }
  new Chart($(canvas_id), {
    type: chart_data.type,
    data: chart_data,
    options: {
      responsive: true,
      legend: { display: false },
      title: { display: true, text: title },
      scales: {
        xAxes: [ { stacked: true, ticks: { beginAtZero: true } } ],
        yAxes: [{
          stacked: true,
          ticks: { beginAtZero: true },
          afterFit: function(scaleInstance) {
            if (chart_data.type=='horizontalBar') {
              scaleInstance.width = 180;
            }
          }
        }]
      },
    },
  });
}
