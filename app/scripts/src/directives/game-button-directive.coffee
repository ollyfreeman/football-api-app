angular.module 'footballAPI'

.directive 'gameButton', ->

    gameButtonDirective =
        restrict: 'E'
        templateUrl: './app/templates/game-button-template.html'