angular.module 'footballAPI'

.factory 'DataFormatter', ['DATA', 'TIME', (DATA, TIME) ->

    dataFormatter = {}

    # created a formattedMatch containing the basic information about each match
    dataFormatter.processRawMatch = (rawMatch) ->
        formattedMatch =
            home_team: rawMatch.match_localteam_name
            away_team: rawMatch.match_visitorteam_name
            home_score: 0
            away_score: 0
            events: []
            currentResult: [DATA.DRAW]
        return formattedMatch

    # edit the supplied formattedMatches and globalEvents data,
    # given the rawData and the current dataTime
    dataFormatter.processLiveData = (dataTime, formattedMatches, globalEvents, rawData) ->

        # for each match, set up the necessary variables
        for i in [0...formattedMatches.length]
            rawMatch = rawData.matches[i]
            formattedMatch = formattedMatches[i]
            rawEvents = rawMatch.match_events
            matchTime = getTime rawMatch[DATA.MATCH_TIMER], rawMatch

            # process all match events that have occured since last call to processLiveData
            # i.e. we allow for missed server responses
            for j in [formattedMatch.events.length...rawEvents.length]
                rawEvent = rawEvents[j]
                eventTime = getTime parseInt(rawEvent[DATA.EVENT_TIME]), rawMatch

                # if rawEvent was a goal,
                #we need to change match scores and currentResult accordingly
                if rawEvent[DATA.EVENT_TYPE] == DATA.EVENT_TYPE_GOAL
                    [homeScore, awayScore] = rawEvent[DATA.EVENT_RESULT]
                                                .replace '[', ''
                                                .replace ']', ''
                                                .split ' - '
                                                .map (el) -> parseInt(el)
                    # set match scores
                    formattedMatch.home_score = homeScore
                    formattedMatch.away_score = awayScore
                    # set currentResult
                    formattedMatch.currentResult[eventTime] =
                        getCurrentResult homeScore, awayScore

                # set the event_team field from 'localteam' or 'visitorteam'
                # to the actual team name - to help with tooltips
                rawEvent[DATA.EVENT_TEAM] = getEventTeam(
                                                rawEvent,
                                                formattedMatch.home_team,
                                                formattedMatch.away_team)

                # add the event to the formattedMatch events list
                formattedMatch.events.push rawEvent
                # add the event to the global events list
                addEventToGlobalEvents rawEvent, eventTime, globalEvents

            # allowing for missed server responses...
            for j in [dataTime+1..matchTime]
                # ...set currentResult in the case that there was no event
                unless formattedMatch.currentResult[j]
                    formattedMatch.currentResult[j] = formattedMatch.currentResult[j - 1]

        return matchTime

    # Fills in the current result for timeslots during half-time
    dataFormatter.formatCurrentResults = (time, matches) ->
        for match in matches
            if TIME.HALFTIME_START <= time <= TIME.HALFTIME_END
                match.currentResult[time] = match.currentResult[time - 1]

    # retuns an integer that is:
    # 0-45 if in the first half, 45 if in half time,
    # 61-106 if in the second half, and 106 if the match is over
    getTime = (rawTime, rawMatch) ->
        if rawMatch[DATA.MATCH_TIMER] is DATA.MATCH_TIMER_FINISHED
            return TIME.SECONDHALF_END
        else
            if isSecondHalf(rawMatch) then offset = TIME.SECONDHALF_START - TIME.FIRSTHALF_END
            else offset = TIME.FIRSTHALF_START
            return offset + parseInt rawMatch[DATA.MATCH_TIMER]

    isSecondHalf = (rawMatch) ->
        haveReachedHalfTime = rawMatch[DATA.HT_SCORE] isnt DATA.HT_SCORE_NOT_REACHED
        isntHalfTime = rawMatch[DATA.MATCH_STATUS] isnt DATA.MATCH_STATUS_HT
        return haveReachedHalfTime and isntHalfTime

    getCurrentResult = (homeScore, awayScore) ->
        scoreDiff = homeScore - awayScore
        if scoreDiff > 0 then actual = DATA.HOME_WIN
        else if scoreDiff < 0 then actual = DATA.AWAY_WIN
        else actual = DATA.DRAW

    getEventTeam = (rawEvent, homeTeam, awayTeam) ->
        if rawEvent[DATA.EVENT_TEAM] is DATA.HOME_TEAM then homeTeam else awayTeam

    addEventToGlobalEvents = (rawEvent, matchTime, globalEvents) ->
        unless globalEvents[matchTime] then globalEvents[matchTime] = [rawEvent]
        else globalEvents[matchTime].push rawEvent

    return dataFormatter
]