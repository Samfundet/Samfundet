$(document).on('render_async_load', function(event) {
$('#div-chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Average Purchase',
                align: 'center'
            },
            subtitle: {
                text: ' '
            },
            xAxis: {
                categories: <?php echo json_encode($result['day']) ?>,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Amount (Millions)'
                }
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Purchase',
                data: <?php echo json_encode($result['amount']) ?>
            }]
      });
}
);
