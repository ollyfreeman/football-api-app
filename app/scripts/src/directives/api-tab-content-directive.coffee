angular.module 'footballAPI'

.directive('apiTabContent', () ->

    return {
        restrict: 'E'
        replace: false
        templateUrl: './app/templates/api-tab-content-template.html'
        controller: 'ApiTabContentController'
        controllerAs: 'apiTabCtrl'
    }
)