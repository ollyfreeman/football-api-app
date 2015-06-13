angular.module 'footballAPI', ['chart.js', 'ngMaterial']

.config(['ChartJsProvider', (ChartJsProvider) ->
    # configure all charts
    ChartJsProvider.setOptions({
        colours: ['#3F51B5', '#FF4081']
        responsive: false
        showTooltips: false

        scaleOverride: true
        scaleSteps: 5
        scaleStepWidth: 20
        scaleStartValue: 0
        scaleLabel: ' <%=value%>'
    })
    # configure all line charts
    ChartJsProvider.setOptions('Line', {
        pointDot: false
        bezierCurve: false
    })
    return
])