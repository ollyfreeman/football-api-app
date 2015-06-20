angular.module 'footballAPI'

.directive 'gameMatches', ->

    gameMatchesDirective =
        restrict: 'E'
        replace: true
        templateUrl: './app/templates/matches-template.html'