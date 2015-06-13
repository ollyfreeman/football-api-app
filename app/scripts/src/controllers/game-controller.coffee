angular.module 'footballAPI'

.controller('GameController'\
, [ 'Data', 'GlobalEvents', 'Graph', 'PlayerScore', 'Prediction'
, '$interval', 'BUTTON', 'CONFIG', 'TIME'
, (Data, GlobalEvents, Graph, PlayerScore, Prediction, $interval, BUTTON, CONFIG, TIME) ->

    ctrl = this
    ctrl.simulationTime = 0
    ctrl.matchSpeed = CONFIG.MATCH_SPEED
    ctrl.simulationReady = false
    ctrl.buttonText = BUTTON.PRE_START

    ctrl.matches = Data.matches
    ctrl.predictions = Prediction.predictions

    # initialise the various services
    Data.initialise().then () ->
        Prediction.initialise()
        GlobalEvents.initialise()
        PlayerScore.initialise()
        Graph.initialise()

        ctrl.simulationReady = true
        ctrl.buttonText = BUTTON.START
    , () ->
        ctrl.simulationReady = false
        ctrl.buttonText = BUTTON.ERROR_START

    # start the simulation
    ctrl.startSimulation = () ->
        lengthOfSimulatedMinute = TIME.SIXTY_SECONDS/ctrl.matchSpeed

        Data.startMatch(ctrl.matchSpeed).then () ->
            ctrl.simulationReady = false
            ctrl.buttonText = BUTTON.IN_PROGRESS
            # execute once per simulated minute
            intervalId = newInterval(lengthOfSimulatedMinute, () ->

                # finish the simulation if full time is reached
                finishSimulation(intervalId) if ctrl.simulationTime >= TIME.SECONDHALF_END

                # TODO: go onto 1 second poll if we are ahead of the server

                # extra formatting that requires knowledge of simulation time
                Data.formatCurrentResults(ctrl.simulationTime)

                # store prediction for this minute
                Prediction.recordPrediction(ctrl.simulationTime)

                # Create the tooltip for any events that occured
                GlobalEvents.addEventTooltip(ctrl.simulationTime)

                # calculate the playerScore
                PlayerScore.calculatePlayerScore(ctrl.simulationTime)

                # increase the simulation time
                ctrl.simulationTime += 1
            )
        , () ->
            ctrl.simulationReady = false
            ctrl.buttonText = BUTTON.ERROR_GAME

    ctrl.changePrediction = (prediction, matchIndex) ->
        Prediction.changePrediction(prediction,
                                    Data.matches[matchIndex].home_team,
                                    Data.matches[matchIndex].away_team,
                                    ctrl.simulationTime, matchIndex)

    # helper methods
    newInterval = (interval, callback) ->
        return $interval(callback, interval)

    finishSimulation = (intervalId) ->
        ctrl.simulationReady = false
        ctrl.buttonText = BUTTON.FINISHED
        $interval.cancel(intervalId)

    return ctrl
])
