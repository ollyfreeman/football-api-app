angular.module 'footballAPI'

.directive 'gameScore', [ 'PlayerScore', (PlayerScore) ->

    gameScoreDirective =
        restrict: 'E'
        templateUrl: './html/templates/game-score-template.html'
        controller: () ->
            @playerScore = PlayerScore.currentPlayerScore
            return @
        controllerAs: 'gameScoreCtrl'
]