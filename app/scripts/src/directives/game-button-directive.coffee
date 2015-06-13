angular.module 'footballAPI'

.directive('gameButton', () ->

    return {
        restrict: 'E'
        templateUrl: './templates/game-button-template.html'
    }
)