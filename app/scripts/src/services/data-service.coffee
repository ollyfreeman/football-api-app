angular.module 'footballAPI'

.factory('Data', ['DataFormatter', '$http', '$interval', '$q', '$timeout', 'TIME', 'URL', (DataFormatter, $http, $interval, $q, $timeout, TIME, URL) ->

    dataService = {}
    dataService.time = TIME.INITIAL_TIME
    dataService.matches = []
    dataService.globalEvents = []

    # retrieve the basic information about each match
    dataService.getInitalMatchInfo = () ->
        return $q (resolve, reject) ->
            $http.get(URL.GET_INITIAL_MATCH_INFO).success((data, status) ->
                dataService.matches.push(DataFormatter.processRawMatch(match)) for match in data
                resolve()
            ).error((data, status) ->
                reject()
            )

    # start the simulation
    dataService.startMatch = (matchSpeed) ->
        lengthOfSimulatedMinute = TIME.SIXTY_SECONDS/matchSpeed
        startSimulationURL = "#{URL.START_SIMULATON_PREFIX}#{matchSpeed}"

        return $q (resolve, reject) ->
            $http.get(startSimulationURL).success((data, status) ->
                tokenId = data.tokenId
                getSimulationUpdateURL = "#{URL.GET_SIMULATON_UPDATE_PREFIX}#{tokenId}"

                # execute once per simulated minute
                intervalId = executeAndNewInterval(lengthOfSimulatedMinute, () ->
                    $http.get(getSimulationUpdateURL).success((data, status) ->
                        dataService.time = DataFormatter.processLiveData(
                                            dataService.time,
                                            dataService.matches,
                                            dataService.globalEvents,
                                            data)
                        resolve()
                        stopFetching(intervalId) if dataService.time >= TIME.SECONDHALF_END
                    ).error((data, status) ->
                        stopFetching(intervalId)
                        reject()
                    )
                )
            ).error((data, status) ->
                reject()
            )

    executeAndNewInterval = (interval, callback) ->
        callback()
        return $interval(callback, interval)

    stopFetching = (intervalId) ->
        $interval.cancel(intervalId)

    return dataService
])