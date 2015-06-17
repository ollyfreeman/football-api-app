angular.module 'footballAPI'

.directive('appFooter', () ->

    return {
        restrict: 'E'
        replace: true
        templateUrl: './app/templates/footer-template.html'
    }
)