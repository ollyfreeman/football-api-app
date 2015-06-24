angular.module 'footballAPI'

.directive 'gameButton', ->

    gameButtonDirective =
        restrict: 'E'
        templateUrl: './html/templates/game-button-template.html'