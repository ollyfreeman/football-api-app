angular.module 'footballAPI'

.directive 'appFooter', ->

    appFooterDirective =
        restrict: 'E'
        replace: true
        templateUrl: './html/templates/footer-template.html'