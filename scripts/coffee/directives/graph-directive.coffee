angular.module 'footballAPI'

.directive 'gameGraph', ->

    gameGraphDirective =
        restrict: 'E'
        templateUrl: './html/templates/graph-template.html'
        controller: 'GraphController'
        controllerAs: 'graphCtrl'