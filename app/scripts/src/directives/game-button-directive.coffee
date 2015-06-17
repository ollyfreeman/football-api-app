angular.module 'footballAPI'

.directive('gameButton', () ->

    return {
        restrict: 'E'
        templateUrl: './app/templates/game-button-template.html'
    }
)