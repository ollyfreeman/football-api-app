angular.module 'footballAPI'

.controller('GraphController', [ 'Graph', (Graph) ->
    ctrl = this

    ctrl.data = Graph.data
    ctrl.labels = Graph.labels

    return ctrl
])