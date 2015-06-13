angular.module 'footballAPI'

.directive('appToolbar', () ->

    return {
        restrict: 'E'
        replace: true
        templateUrl: './templates/header-template.html'
        controller: 'HeaderController'
        controllerAs: 'headerCtrl'
    }
)