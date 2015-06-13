angular.module 'footballAPI'

.directive('gameMatches', () ->

    return {
        restrict: 'E'
        replace: true
        templateUrl: './templates/matches-template.html'
    }
)