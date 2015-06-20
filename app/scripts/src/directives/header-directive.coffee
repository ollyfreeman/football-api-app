angular.module 'footballAPI'

.directive 'appToolbar', ->

    appToolbarDirective =
        restrict: 'E'
        replace: true
        templateUrl: './app/templates/header-template.html'
        controller: 'HeaderController'
        controllerAs: 'headerCtrl'