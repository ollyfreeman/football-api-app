angular.module 'footballAPI'

.directive('gameScore', [ 'PlayerScore', (PlayerScore) ->

    return {
        restrict: 'E'
        templateUrl: './app/templates/game-score-template.html'
        controller: () ->
            this.playerScore = PlayerScore.currentPlayerScore
            return this
        controllerAs: 'gameScoreCtrl'
    }
])