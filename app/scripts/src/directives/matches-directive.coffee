angular.module 'footballAPI'

.directive('gameMatches', () ->

    return {
        restrict: 'E'
        replace: true
        templateUrl: './app/templates/matches-template.html'
    }
)