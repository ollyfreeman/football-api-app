angular.module 'footballAPI'

.controller 'GraphController', [ 'Graph', (Graph) ->
    ctrl = @

    ctrl.data = Graph.data
    ctrl.labels = Graph.labels

    return ctrl
]