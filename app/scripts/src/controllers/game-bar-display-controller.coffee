angular.module 'footballAPI'

.controller('GameBarDisplayController'\
, [ 'Labels', 'GlobalEvents', 'Prediction', '$scope'
, (Labels, GlobalEvents, Prediction, $scope) ->

    ctrl = this

    ctrl.title = $scope.title

    if ctrl.title is 'Predictions'
        ctrl.tooltips = Prediction.predictionTooltips.list
    else
        ctrl.tooltips = GlobalEvents.eventTooltips.list

    ctrl.tooltipLabels = Labels.tooltipLabels

    return ctrl
])