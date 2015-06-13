(function() {
  angular.module('footballAPI', ['chart.js', 'ngMaterial']).config([
    'ChartJsProvider', function(ChartJsProvider) {
      ChartJsProvider.setOptions({
        colours: ['#3F51B5', '#FF4081'],
        responsive: false,
        showTooltips: false,
        scaleOverride: true,
        scaleSteps: 10,
        scaleStepWidth: 0.1,
        scaleStartValue: 0.00,
        scaleLabel: ' <%=value%>'
      });
      ChartJsProvider.setOptions('Line', {
        pointDot: false,
        bezierCurve: false
      });
    }
  ]);

}).call(this);
