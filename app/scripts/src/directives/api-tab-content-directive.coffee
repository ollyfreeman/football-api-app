angular.module 'footballAPI'

.directive('apiTabContent', () ->

    return {
        restrict: 'E'
        replace: false
        templateUrl: './templates/api-tab-content-template.html'
        controller: 'ApiTabContentController'
        controllerAs: 'apiTabCtrl'
    }
)