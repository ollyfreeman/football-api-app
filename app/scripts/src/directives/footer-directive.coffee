angular.module 'footballAPI'

.directive('appFooter', () ->

    return {
        restrict: 'E'
        templateUrl: './templates/footer-template.html'
    }
)