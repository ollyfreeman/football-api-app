angular.module 'footballAPI'

.directive('gameBarDisplay', [ 'Labels', 'GlobalEvents', (Labels, GlobalEvents) ->

    return {
        restrict: 'E'
        templateUrl: './app/templates/game-bar-display-template.html'
        scope: {
            description: '@'
        }
        controller: 'GameBarDisplayController'
        controllerAs: 'gameBarDisplayCtrl'
    }
])