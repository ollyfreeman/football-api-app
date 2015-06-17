angular.module 'footballAPI'

.directive('gameGraph', () ->

    return {
        restrict: 'E'
        templateUrl: './app/templates/graph-template.html'
        controller: 'GraphController'
        controllerAs: 'graphCtrl'
    }
)