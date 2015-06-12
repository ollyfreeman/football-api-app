#PROBABLY ALSO REFACTOR THIS INTO A data-fetcher service and a data-parser service
#ALSO need a 'constants' file

app = angular.module('footballAPI')

app.factory('DataService', ['$http', '$q', '$interval', '$timeout', ($http, $q, $interval, $timeout) ->
    dataService = {}
    SIXTY_SECONDS = 60000
    dataService.time = -1
    dataService.matches = []
    dataService.events = []

    dataService.getInitalMatchInfo = () ->
        return $q (resolve, reject) ->
            getInitialMatchInfoURL = 'http://localhost:8080/api/?Action=matches'
            $http.get(getInitialMatchInfoURL).success((data, status) ->
                processRawMatch(dataService, match) for match in data
                resolve()
            ).error((data, status) ->
                reject()
            )

    dataService.startMatch = (matchSpeed) ->
        lengthOfSimulatedMinute = SIXTY_SECONDS/matchSpeed
        startSimulationURL = "http://localhost:8080/api/?Action=start&matchspeed=#{matchSpeed}"

        return $q (resolve, reject) ->
            $http.get(startSimulationURL).success((data, status) ->
                resolve()
                tokenId = data.tokenId
                getSimulationUpdateURL = "http://localhost:8080/api/?Action=today&tokenId=#{tokenId}"
                intervalId = executeAndNewInterval(lengthOfSimulatedMinute, () ->
                    $http.get(getSimulationUpdateURL).success((data, status) ->
                        processLiveData(dataService, data, tokenId)
                        $interval.cancel(intervalId) if dataService.time >= 106
                    ).error((data, status) ->
                        $interval.cancel(intervalId)
                    )
                )
            ).error((data, status) ->
                reject()
            )

    executeAndNewInterval = (interval, callback) ->
        callback()
        return $interval(callback, interval)

    newTimeout = (interval, callback) ->
        return $timeout(callback, interval)

    return dataService
])

processRawMatch = (dataService, rawMatch) ->
    formattedMatch = {}
    formattedMatch.home_team = rawMatch.match_localteam_name
    formattedMatch.away_team = rawMatch.match_visitorteam_name
    formattedMatch.home_score = 0
    formattedMatch.away_score = 0
    formattedMatch.events = []
    formattedMatch.currentResults = ['draw']
    dataService.matches.push(formattedMatch)

processLiveData = (dataService, data, tokenId) ->
    rawMatchTime = dataService.time
    for i in [0...data.matches.length] by 1
        rawMatch = data.matches[i]
        formattedMatch = dataService.matches[i]
        rawMatchTime = if rawMatch.match_timer is '' then 106 else (parseInt(rawMatch.match_timer) + (if isSecondHalf(rawMatch) then 16 else 0))
        rawEvents = rawMatch.match_events
        for j in [formattedMatch.events.length...rawEvents.length] by 1
            rawEvent = rawEvents[j]
            rawEventTime = parseInt(rawEvent.event_minute)
            if rawEvent.event_type == 'goal'
                [homeScore, awayScore] = rawEvent.event_result.replace('[','').replace(']','').split(' - ').map((el) -> parseInt(el))
                formattedMatch.home_score = homeScore
                formattedMatch.away_score = awayScore
                formattedMatch.currentResults[rawEventTime] = getCurrentResult(homeScore, awayScore)
            rawEvent.event_team = if rawEvent.event_team is 'localteam' then formattedMatch.home_team else formattedMatch.away_team
            formattedMatch.events.push(rawEvent)
            if not dataService.events[rawMatchTime]
                dataService.events[rawMatchTime] = [rawEvent]
            else
                dataService.events[rawMatchTime].push(rawEvent)
        for j in [dataService.time + 1..rawMatchTime] by 1
            if not formattedMatch.currentResults[j]
                formattedMatch.currentResults[j] = formattedMatch.currentResults[j - 1]
    dataService.time = rawMatchTime

getCurrentResult = (homeScore, awayScore) ->
    scoreDiff = homeScore - awayScore
    if scoreDiff > 0 then actual = 'home' else if scoreDiff < 0 then actual = 'away' else actual = 'draw'

isSecondHalf = (rawMatch) ->
    (rawMatch.match_ht_score isnt '') and (rawMatch.match_status isnt 'HT')
