angular.module 'footballAPI'

.directive 'apiTabContent', ->

    apiTabContentDirective =
        restrict: 'E'
        replace: false
        templateUrl: './html/templates/api-tab-content-template.html'
        controller: 'ApiTabContentController'
        controllerAs: 'apiTabCtrl'