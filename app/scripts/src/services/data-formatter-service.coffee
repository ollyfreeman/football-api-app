angular.module 'footballAPI'

.factory('DataFormatterService', ['DATA', 'TIME', (DATA, TIME) ->

    dataFormatterService = {}

    dataFormatterService.processRawMatch = (rawMatch) ->
        formattedMatch = {}
        formattedMatch.home_team = rawMatch.match_localteam_name
        formattedMatch.away_team = rawMatch.match_visitorteam_name
        formattedMatch.home_score = 0
        formattedMatch.away_score = 0
        formattedMatch.events = []
        formattedMatch.currentResult = [DATA.DRAW]
        return formattedMatch

    dataFormatterService.processLiveData = (dataTime, formattedMatches, globalEvents, rawData) ->

        for i in [0...formattedMatches.length]
            rawMatch = rawData.matches[i]
            formattedMatch = formattedMatches[i]
            matchTime = getMatchTime(rawMatch)
            rawEvents = rawMatch.match_events

            # process match events (allowing for missed server responses)
            for j in [formattedMatch.events.length...rawEvents.length]
                rawEvent = rawEvents[j]
                rawEventTime = parseInt(rawEvent[DATA.EVENT_TIME])

                if rawEvent[DATA.EVENT_TYPE] == DATA.EVENT_TYPE_GOAL
                    [homeScore, awayScore] = rawEvent[DATA.EVENT_RESULT].replace('[','').replace(']','').split(' - ').map((el) -> parseInt(el))
                    formattedMatch.home_score = homeScore
                    formattedMatch.away_score = awayScore
                    formattedMatch.currentResult[rawEventTime] = getCurrentResult(homeScore, awayScore)

                rawEvent[DATA.EVENT_TEAM] = getEventTeam(rawEvent, formattedMatch.home_team, formattedMatch.away_team)
                formattedMatch.events.push(rawEvent)

                addEventToGlobalEvents(rawEvent, matchTime, globalEvents)

            # set currentResult in the case that there was no event (allowing for missed server responses)
            for j in [dataTime+1..matchTime]
                if not formattedMatch.currentResult[j]
                    formattedMatch.currentResult[j] = formattedMatch.currentResult[j - 1]

        return matchTime

    getMatchTime = (rawMatch) ->
        if rawMatch[DATA.MATCH_TIMER] is DATA.MATCH_TIMER_FINISHED
            TIME.SECONDHALF_END
        else
            offset = if isSecondHalf(rawMatch) then TIME.SECONDHALF_START-TIME.FIRSTHALF_END else TIME.FIRSTHALF_START
            parseInt(rawMatch[DATA.MATCH_TIMER]) + offset

    isSecondHalf = (rawMatch) ->
        (rawMatch[DATA.HT_SCORE] isnt DATA.HT_SCORE_NOT_REACHED) and (rawMatch[DATA.MATCH_STATUS] isnt DATA.MATCH_STATUS_HT)

    getCurrentResult = (homeScore, awayScore) ->
        scoreDiff = homeScore - awayScore
        if scoreDiff > 0 then actual = DATA.HOME_WIN else if scoreDiff < 0 then actual = DATA.AWAY_WIN else actual = DATA.DRAW

    getEventTeam = (rawEvent, homeTeam, awayTeam) ->
        if rawEvent[DATA.EVENT_TEAM] is DATA.HOME_TEAM then homeTeam else awayTeam

    addEventToGlobalEvents = (rawEvent, matchTime, globalEvents) ->
        if not globalEvents[matchTime]
            globalEvents[matchTime] = [rawEvent]
        else
            globalEvents[matchTime].push(rawEvent)

    return dataFormatterService
])
