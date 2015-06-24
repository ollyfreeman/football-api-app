angular.module 'footballAPI'

.directive 'rulesTabContent', ->

    rulesTabContentDirective =
        restrict: 'E'
        replace: false
        templateUrl: './html/templates/rules-tab-content-template.html'
        controller: 'RulesTabContentController'
        controllerAs: 'rulesTabCtrl'