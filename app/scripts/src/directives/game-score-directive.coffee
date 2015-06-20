angular.module 'footballAPI'

.directive 'gameScore', [ 'PlayerScore', (PlayerScore) ->

    gameScoreDirective =
        restrict: 'E'
        templateUrl: './app/templates/game-score-template.html'
        controller: () ->
            @playerScore = PlayerScore.currentPlayerScore
            return @
        controllerAs: 'gameScoreCtrl'
]