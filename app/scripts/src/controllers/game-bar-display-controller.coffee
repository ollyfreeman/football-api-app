angular.module 'footballAPI'

.controller 'GameBarDisplayController'\
, [ 'Labels', 'GlobalEvents', 'Prediction', '$scope'
, (Labels, GlobalEvents, Prediction, $scope) ->
    ctrl = @

    ctrl.barTitle = $scope.description

    if ctrl.barTitle is 'Predictions'
        ctrl.tooltips = Prediction.predictionTooltips.list
    else
        ctrl.tooltips = GlobalEvents.eventTooltips.list

    ctrl.tooltipLabels = Labels.tooltipLabels

    return ctrl
]