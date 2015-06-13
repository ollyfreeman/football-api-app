angular.module 'footballAPI'

.directive('appToolbar', () ->

    return {
        restrict: 'E'
        templateUrl: './templates/header-template.html'
        controller: 'HeaderController'
        controllerAs: 'headerCtrl'
    }
)