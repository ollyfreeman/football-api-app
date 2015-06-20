angular.module 'footballAPI'

.directive 'appFooter', ->

    appFooterDirective =
        restrict: 'E'
        replace: true
        templateUrl: './app/templates/footer-template.html'