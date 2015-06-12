angular.module 'footballAPI'

# SPLIT THIS INTO A Matches, Graph and Table ctrl - all share the same data object (which is init by dataFetcher, which the MatchesController accesses)
# exposed get (and set) methods on the data object to keep things tight
.controller('MatchController', ['DataService', '$http', '$interval', 'DATA', 'GRAPH', 'TIME', (DataService, $http, $interval, DATA, GRAPH, TIME) ->

    ctrl = this
    ctrl.simulationReady = false
    ctrl.simulationTime = 0
    ctrl.matchSpeed = 200

    # formatted data for each match
    ctrl.matches = []
    # list of events that occur in every time slot
    ctrl.globalEvents = []
    # predictions for each match
    ctrl.predictions = []
    # prediction tooltip text
    ctrl.predictionTooltips = {}
    # event tooltip text
    ctrl.eventTooltips = {}
    # player score for every time slot
    ctrl.playerScore = []
    # data used for angular-chart
    ctrl.graphData = []
    # labels for angular-chart
    ctrl.graphLabels = []

    # retrieve the basic information about each match
    # and initialise the controller properties accordingly
    DataService.getInitalMatchInfo().then () ->
        initaliseMatches()
        initaliseEvents()
        initialisePredictions()
        initialisePredictionTooltips()
        initialiseEventTooltips()
        initialisePlayerScore()
        initialiseGraphData()
        initialiseGraphLabels()
        ctrl.simulationReady = true
    , () ->
        console.log(':(')

    # start the simulation
    ctrl.startSimulation = () ->
        lengthOfSimulatedMinute = TIME.SIXTY_SECONDS/ctrl.matchSpeed

        DataService.startMatch(ctrl.matchSpeed).then () ->
            # execute once per simulated minute
            intervalId = newInterval(lengthOfSimulatedMinute, () ->

                # finish the simulation if full time is reached
                finishSimulation(intervalId) if ctrl.simulationTime >= TIME.SECONDHALF_END

                # TODO: go onto 1 second poll if we are ahead of the server

                # TODO: comment
                formatCurrentResults()

                # store prediction for this minute
                recordPrediction()

                # TODO: comment
                addEventTooltip()

                # calculate the playerScore
                calculatePlayerScore()

                # increase the simulation time
                ctrl.simulationTime += 1
            )
        , () ->
            console.log(':(')

    # change the current prediction for a given match
    ctrl.changePrediction = (matchIndex) ->
        ctrl.predictions[matchIndex].lastChange = ctrl.simulationTime
        addPredictionTooltip(matchIndex)

    ###
    Initialisers
    ###

    initaliseMatches = () ->
        ctrl.matches = DataService.matches

    initaliseEvents = () ->
        ctrl.globalEvents = DataService.globalEvents

    initialisePredictions = () ->
        for match in ctrl.matches
            ctrl.predictions.push({ current: DATA.DRAW, lastChange: TIME.FIRSTHALF_START, list: [DATA.DRAW] })

    initialisePredictionTooltips = () ->
        ctrl.predictionTooltips.list = (null for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])
        ctrl.predictionTooltips.mostRecent = (null for match in ctrl.matches)

    initialiseEventTooltips = () ->
        ctrl.eventTooltips.list = (null for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])

    initialisePlayerScore = () ->
        ctrl.playerScore = (0 for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])

    initialiseGraphData = () ->
        ctrl.graphData.push(ctrl.playerScore)

    initialiseGraphLabels = () ->
        ctrl.graphLabels.push('') for i in [TIME.FIRSTHALF_START..TIME.SECONDHALF_END]
        ctrl.graphLabels[i] = "#{i}FH" for i in[TIME.FIRSTHALF_START..TIME.FIRSTHALF_END - 1] by GRAPH.LABEL_GAP
        ctrl.graphLabels[i] = "#{i-TIME.HALFTIME_START}HT" for i in[TIME.HALFTIME_START..TIME.HALFTIME_END] by GRAPH.LABEL_GAP
        ctrl.graphLabels[i] = "#{i-(TIME.SECONDHALF_START-TIME.FIRSTHALF_END)}SH" for i in[TIME.SECONDHALF_START..TIME.SECONDHALF_END] by GRAPH.LABEL_GAP


    ###
    startSimulation helper methods
    ###

    newInterval = (interval, callback) ->
        return $interval(callback, interval)

    finishSimulation = (intervalId) ->
        $interval.cancel(intervalId)
        console.log 'Match Finished.'

    addEventTooltip = () ->
        if ctrl.globalEvents[ctrl.simulationTime]
            eventTooltipString = ''
            for event in ctrl.globalEvents[ctrl.simulationTime]
                eventString = "#{event.event_team} - #{event.event_type} - #{event.event_player} - #{event.event_minute}"
                eventTooltipString += "#{eventString} ---"
            ctrl.eventTooltips.list[ctrl.simulationTime] = eventTooltipString

    calculatePlayerScore = () ->
        totalScore = 0
        numberOfMatches = ctrl.matches.length
        finalNumberOfPredictions = TIME.SECONDHALF_END + 1

        for i in [0...numberOfMatches]
            prediction = ctrl.predictions[i]
            match = ctrl.matches[i]
            predictionWasCorrect = prediction.list[ctrl.simulationTime] is match.currentResult[ctrl.simulationTime]
            totalScore += ((finalNumberOfPredictions - prediction.lastChange)/finalNumberOfPredictions) * predictionWasCorrect
        ctrl.playerScore[ctrl.simulationTime] = totalScore / numberOfMatches

    formatCurrentResults = () ->
        for match in ctrl.matches
            if TIME.HALFTIME_START <= ctrl.simulationTime <= TIME.HALFTIME_END
                match.currentResult[ctrl.simulationTime] = match.currentResult[ctrl.simulationTime - 1]

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
            for i in[0...ctrl.matches.length]
                if ctrl.predictions[i].lastChange is ctrl.simulationTime
                    predictionTooltipString += "#{ctrl.predictionTooltips.mostRecent[i]} --- "
            ctrl.predictionTooltips.list[ctrl.simulationTime] = predictionTooltipString


    ###
    return the controller
    ###

    return ctrl
])