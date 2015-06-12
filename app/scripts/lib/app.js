(function() {
  angular.module('footballAPI', ['chart.js']).config([
    'ChartJsProvider', function(ChartJsProvider) {
      ChartJsProvider.setOptions({
        colours: ['#FF5252', '#FF8A80'],
        responsive: false,
        showTooltips: false,
        scaleOverride: true,
        scaleSteps: 10,
        scaleStepWidth: 0.1,
        scaleStartValue: 0.00
      });
      ChartJsProvider.setOptions('Line', {
        pointDot: false,
        bezierCurve: false
      });
    }
  ]);

}).call(this);
