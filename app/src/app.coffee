app = angular.module('footballAPI',[])

# SPLIT THIS INTO A Matches, Graph and Table controller - all share the same data object (which is init by dataFetcher, which the MatchesController accesses)
# exposed get (and set) methods on the data object to keep things tight
.controller('MatchController', ['DataService', '$http', '$interval', (DataService, $http, $interval) ->

    controller = this
    controller.simulationReady = false
    controller.matchSpeed = 600
    SIXTY_SECONDS = 60000
    #TODO: graph data and labels
    controller.matches = DataService.matches

    DataService.getInitalMatchInfo().then () ->
        controller.simulationReady = true
    , () ->
        console.log(':(')

    controller.startSimulation = () ->
        lengthOfSimulatedMinute = SIXTY_SECONDS/controller.matchSpeed

        DataService.startMatch(controller.matchSpeed).then () ->
            intervalId = executeAndNewInterval(lengthOfSimulatedMinute, () ->
                $interval.cancel(intervalId) if DataService.time >=106
                console.log DataService.matches
                #TODO
            )
        , () ->
            console.log(':(')

    executeAndNewInterval = (interval, callback) ->
        callback()
        return $interval(callback, interval)

    return controller
])


