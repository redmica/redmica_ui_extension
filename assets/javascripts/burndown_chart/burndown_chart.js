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
      maintainAspectRatio: false,
      parsing: {
        xAxisKey: 't'
      },
      plugins: {
        legend: {
          position: 'top',
          labels: { boxWidth: 20, font: { size: 10 }, padding: 10 }
        },
        title: { display: true, text: title },
        tooltip: {
          callbacks: {
            title: function(tooltipItem, data) { return '' }
          }
        }
      },
      scales: {
        x: {
          type: "time",
          time: { unit: "day", displayFormats: { day: 'yyyy-MM-dd' } },
          grid: { borderDash: [6, 4] },
          ticks: { source: 'labels', autoSkip: true }
        },
        y: {
          title: { display: true, text: y_label },
          grid: { borderDash: [6, 4] },
          ticks: y_axes_ticks
        }
      }
    }
  });
}
