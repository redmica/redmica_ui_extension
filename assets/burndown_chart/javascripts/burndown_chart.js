function renderChart(canvas_id, title, y_label, y_lim, chartData){
  y_axes_ticks = { min: 0, max: y_lim };
  if (y_lim > 35) {
    y_axes_ticks['autoSkip'] = true;
  } else {
    y_axes_ticks['stepSize'] = 1;
  }
  new Chart($(canvas_id), {
    type: 'line',
    data: chartData,
    options: {
      responsive: true,
      legend: {
        position: 'right',
        labels: { boxWidth: 20, fontSize: 10, padding: 10 }
      },
      title: { display: true, text: title },
      tooltips: {
        callbacks: {
          title: function(tooltipItem, data) { return '' }
        }
      },
      scales: {
        xAxes: [{
          type: "time",
          time: { unit: "day", displayFormats: { day: 'YYYY-MM-DD' } },
          gridLines: { borderDash: [6, 4] },
          ticks: { source: 'labels', autoSkip: true }
        }],
        yAxes: [{
          scaleLabel: { display: true, labelString: y_label },
          gridLines: { borderDash: [6, 4] },
          ticks: y_axes_ticks
        }]
      }
    }
  });
}
