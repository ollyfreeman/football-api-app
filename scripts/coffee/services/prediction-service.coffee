angular.module 'footballAPI'

.factory 'Prediction', [ 'Data', 'DATA', 'TIME', (Data, DATA, TIME) ->

    predictionService =
        # predictions for each match
        predictions: []
        # prediction tooltip text
        predictionTooltips:
            list: (null for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])

    predictionService.initialise = ->
        numberOfMatches = Data.matches.length
        initialisePredictions numberOfMatches
        initialisePredictionTooltips numberOfMatches

    # change the current prediction for a given match
    predictionService.changePrediction = (prediction, homeTeam, awayTeam, time, matchIndex) ->
        predictionService.predictions[matchIndex].current = prediction
        predictionService.predictions[matchIndex].lastChange = time
        addPredictionTooltip homeTeam, awayTeam, time, matchIndex

    # record the current prediction for the current time
    predictionService.recordPrediction = (time) ->
        for prediction in predictionService.predictions
            prediction.list[time] = angular.copy prediction.current

    ###
    helper methods
    ###
    initialisePredictions = (numberOfMatches) ->
        for i in [0...numberOfMatches]
            predictionService.predictions.push
                current: DATA.DRAW,
                lastChange: TIME.FIRSTHALF_START,
                list: [DATA.DRAW]

    initialisePredictionTooltips = (numberOfMatches) ->
        predictionService.predictionTooltips.mostRecent = (null for [0...numberOfMatches])

    # add the prediction tooltip for the current time
    addPredictionTooltip = (homeTeam, awayTeam, time, matchIndex) ->
        predictionTooltipString =
            "-#{homeTeam} v #{awayTeam} : #{predictionService.predictions[matchIndex].current}- "
        predictionService.predictionTooltips.mostRecent[matchIndex] = predictionTooltipString

        if predictionService.predictionTooltips.list[time] is null
            predictionService.predictionTooltips.list[time] = predictionTooltipString
        else
            predictionTooltipString = ''
            for i in[0...predictionService.predictions.length]
                if predictionService.predictions[i].lastChange is time
                    predictionTooltipString += predictionService.predictionTooltips.mostRecent[i]
            predictionService.predictionTooltips.list[time] = predictionTooltipString

    return predictionService
]