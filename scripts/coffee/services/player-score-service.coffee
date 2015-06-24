angular.module 'footballAPI'

.factory 'PlayerScore', [ 'Data', 'Prediction', 'TIME', (Data, Prediction, TIME) ->

    playerScoreService =
        playerScore: []
        currentPlayerScore:
            value: 0

    playerScoreService.initialise = ->
        playerScoreService.playerScore = (0 for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])

    playerScoreService.calculatePlayerScore = (time) ->
        totalScore = 0
        numberOfMatches = Data.matches.length
        finalNumberOfPredictions = TIME.SECONDHALF_END + 1

        for i in [0...numberOfMatches]
            prediction = Prediction.predictions[i]
            match = Data.matches[i]
            predictionWasCorrect = prediction.list[time] is match.currentResult[time]
            scoreForMatch = finalNumberOfPredictions - prediction.lastChange
            scoreForMatch /= finalNumberOfPredictions
            totalScore += scoreForMatch * predictionWasCorrect * 100
        playerScoreService.playerScore[time] = totalScore / numberOfMatches
        playerScoreService.currentPlayerScore.value = playerScoreService.playerScore[time]

    return playerScoreService
]