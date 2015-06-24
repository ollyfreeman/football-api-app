angular.module 'footballAPI'

.controller 'RulesTabContentController', [ 'URL', (URL) ->
    ctrl = @

    ctrl.footballApiURL = URL.FOOTBALL_API

    return ctrl
]