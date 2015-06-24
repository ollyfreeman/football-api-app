angular.module 'footballAPI'

.directive 'appToolbar', ->

    appToolbarDirective =
        restrict: 'E'
        replace: true
        templateUrl: './html/templates/header-template.html'
        controller: 'HeaderController'
        controllerAs: 'headerCtrl'