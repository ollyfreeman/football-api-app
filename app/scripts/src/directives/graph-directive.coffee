angular.module 'footballAPI'

.directive('gameGraph', () ->

    return {
        restrict: 'E'
        templateUrl: './templates/graph-template.html'
        controller: 'GraphController'
        controllerAs: 'graphCtrl'
    }
)