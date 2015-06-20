angular.module 'footballAPI'

.directive 'gameGraph', ->

    gameGraphDirective =
        restrict: 'E'
        templateUrl: './app/templates/graph-template.html'
        controller: 'GraphController'
        controllerAs: 'graphCtrl'