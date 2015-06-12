app = angular.module('footballAPI')

# SPLIT THIS INTO A Matches, Graph and Table ctrl - all share the same data object (which is init by dataFetcher, which the MatchesController accesses)
# exposed get (and set) methods on the data object to keep things tight
.controller('MatchController', ['DataService', '$http', '$interval', (DataService, $http, $interval) ->

    ctrl = this
    ctrl.simulationReady = false
    ctrl.simulationTime = 0
    ctrl.matchSpeed = 30

    ctrl.matches = []
    ctrl.predictions = []
    ctrl.predictionTooltips = {}
    ctrl.playerScore = []
    ctrl.graphData = []
    ctrl.graphLabels = []

    SIXTY_SECONDS = 60000

    DataService.getInitalMatchInfo().then () ->
        initaliseMatches()
        initialisePredictions()
        initialisePredictionTooltips()
        initialisePlayerScore()
        initialiseGraphData()
        initialiseGraphLabels()
        ctrl.simulationReady = true
    , () ->
        console.log(':(')

    ctrl.startSimulation = () ->
        lengthOfSimulatedMinute = SIXTY_SECONDS/ctrl.matchSpeed

        DataService.startMatch(ctrl.matchSpeed).then () ->
            # execute this once per simulated minute
            intervalId = newInterval(lengthOfSimulatedMinute, () ->

                # finish the simulation if full time is reached
                finishSimulation(intervalId) if ctrl.simulationTime >=106

                # TODO: go onto 1 second poll if we are ahead of the server

                # store prediction for this minute
                recordPrediction()

                # calculate the playerScore
                calculatePlayerScore()

                # increase the simulation time
                ctrl.simulationTime += 1
            )
        , () ->
            console.log(':(')

    ctrl.changePrediction = (matchIndex) ->
        ctrl.predictions[matchIndex].lastChange = ctrl.simulationTime
        addPredictionTooltip(matchIndex)

    ###
    Initialisers
    ###

    initaliseMatches = () ->
        ctrl.matches = DataService.matches

    initialisePredictions = () ->
        for match in ctrl.matches
            ctrl.predictions.push({ current: 'draw', lastChange: 0, list: ['draw'] })

    initialisePredictionTooltips = () ->
        ctrl.predictionTooltips.list = (null for [0..106])
        ctrl.predictionTooltips.mostRecent = (null for match in ctrl.matches)

    initialisePlayerScore = () ->
        ctrl.playerScore = (0 for [0..106])

    initialiseGraphData = () ->
        ctrl.graphData.push(ctrl.playerScore)

    initialiseGraphLabels = () ->
        ctrl.graphLabels.push('') for i in [0..106] by 1
        ctrl.graphLabels[i] = "#{i}FH" for i in[0..44] by 5
        ctrl.graphLabels[i] = "#{i-46}HT" for i in[46..60] by 5
        ctrl.graphLabels[i] = "#{i-16}SH" for i in[61..106] by 5


    ###
    startSimulation helper methods
    ###

    newInterval = (interval, callback) ->
        return $interval(callback, interval)

    finishSimulation = (intervalId) ->
        $interval.cancel(intervalId)
        console.log 'Match Finished.'

    calculatePlayerScore = () ->
        totalScore = 0
        for i in [0...ctrl.matches.length] by 1
            prediction = ctrl.predictions[i]
            match = ctrl.matches[i]
            #TODO: if it's half time then match.currentResult[ctrl.simulationTime] is only defined on 45/HT
            predictionWasCorrect = prediction.list[ctrl.simulationTime] is match.currentResult[ctrl.simulationTime]
            totalScore += ((107 - prediction.lastChange)/107) * predictionWasCorrect
        totalScore /= ctrl.predictions.length
        ctrl.playerScore[ctrl.simulationTime] = totalScore

    recordPrediction = () ->
        for prediction in ctrl.predictions
            prediction.list[ctrl.simulationTime] = angular.copy(prediction.current)


    ###
    other helper methods
    ###

    addPredictionTooltip = (matchIndex) ->
        match = ctrl.matches[matchIndex]
        predictionTooltipString = """
            #{match.home_team} #{match.home_score} - #{match.away_score} #{match.away_team}
                #{ctrl.predictions[matchIndex].current} (#{ctrl.simulationTime} mins)."""
        ctrl.predictionTooltips.mostRecent[matchIndex] = predictionTooltipString

        if ctrl.predictionTooltips.list[ctrl.simulationTime] is null
            ctrl.predictionTooltips.list[ctrl.simulationTime] = predictionTooltipString
        else
            predictionTooltipString = ''
            for i in[0...ctrl.matches.length] by 1
                if ctrl.predictions[i].lastChange is ctrl.simulationTime
                    predictionTooltipString += "#{ctrl.predictionTooltips.mostRecent[i]} --- "
            ctrl.predictionTooltips.list[ctrl.simulationTime] = predictionTooltipString


    ###
    return the controller
    ###

    return ctrl
])