angular.module 'footballAPI'

.directive('rulesTabContent', () ->

    return {
        restrict: 'E'
        replace: false
        templateUrl: './app/templates/rules-tab-content-template.html'
        controller: 'RulesTabContentController'
        controllerAs: 'rulesTabCtrl'
    }
)