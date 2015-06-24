angular.module 'footballAPI'

.directive 'gameMatches', ->

    gameMatchesDirective =
        restrict: 'E'
        replace: true
        templateUrl: './html/templates/matches-template.html'