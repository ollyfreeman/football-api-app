angular.module 'footballAPI'

.directive('appFooter', () ->

    return {
        restrict: 'E'
        replace: true
        templateUrl: './templates/footer-template.html'
    }
)