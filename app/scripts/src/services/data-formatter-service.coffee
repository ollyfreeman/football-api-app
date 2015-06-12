angular.module 'footballAPI'

.factory('DataFormatter', ['DATA', 'TIME', (DATA, TIME) ->

    # created a formattedMatch containing the basic information about each match
    dataFormatterService.processRawMatch = (rawMatch) ->
        formattedMatch = {}
        formattedMatch.home_team = rawMatch.match_localteam_name
        formattedMatch.away_team = rawMatch.match_visitorteam_name
        formattedMatch.home_score = 0
        formattedMatch.away_score = 0
        formattedMatch.events = []
        formattedMatch.currentResult = [DATA.DRAW]
        return formattedMatch

    # edit the supplied formattedMatches and globalEvents data, given the rawData and the current dataTime
    dataFormatterService.processLiveData = (dataTime, formattedMatches, globalEvents, rawData) ->

        # for each match, set up the necessary variables
        for i in [0...formattedMatches.length]
            rawMatch = rawData.matches[i]
            formattedMatch = formattedMatches[i]
            matchTime = getMatchTime(rawMatch)
            rawEvents = rawMatch.match_events

            # process all match events that have occured since last call to processLiveData
            # i.e. we allow for missed server responses
            for j in [formattedMatch.events.length...rawEvents.length]
                rawEvent = rawEvents[j]
                rawEventTime = parseInt(rawEvent[DATA.EVENT_TIME])

                # if rawEvent was a goal, we need to change match scores and currentResult accordingly
                if rawEvent[DATA.EVENT_TYPE] == DATA.EVENT_TYPE_GOAL
                    [homeScore, awayScore] = rawEvent[DATA.EVENT_RESULT].replace('[','').replace(']','')
                                                                        .split(' - ').map((el) -> parseInt(el))
                    # set match scores
                    formattedMatch.home_score = homeScore
                    formattedMatch.away_score = awayScore
                    # set currentResult
                    formattedMatch.currentResult[rawEventTime] = getCurrentResult(homeScore, awayScore)

                # set the event_team field from 'localteam' or 'visitorteam' to the actual team name - to help with tooltips
                rawEvent[DATA.EVENT_TEAM] = getEventTeam(rawEvent, formattedMatch.home_team, formattedMatch.away_team)

                # add the event to the formattedMatch events list
                formattedMatch.events.push(rawEvent)
                # add the event to the global events list
                addEventToGlobalEvents(rawEvent, matchTime, globalEvents)

            # allowing for missed server responses...
            for j in [dataTime+1..matchTime]
                # ...set currentResult in the case that there was no event
                formattedMatch.currentResult[j] = formattedMatch.currentResult[j - 1] if not formattedMatch.currentResult[j]

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
