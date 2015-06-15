angular.module 'footballAPI'

.controller('RulesTabContentController', [ 'URL', (URL) ->
    ctrl = this

    ctrl.footballApiURL = URL.FOOTBALL_API

    return ctrl
])