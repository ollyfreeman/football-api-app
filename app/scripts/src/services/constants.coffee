angular.module 'footballAPI'

.constant 'DATA', {
    HOME_WIN: 'home win'
    DRAW: 'draw'
    AWAY_WIN: 'away win'

    HOME_TEAM: 'localteam'
    AWAY_TEAM: 'visitorteam'

    HT_SCORE: 'match_ht_score'
    HT_SCORE_NOT_REACHED: ''
    FT_SCORE: 'match_ft_score'
    FT_SCORE_NOT_REACHED: ''
    MATCH_STATUS: 'match_status'
    MATCH_STATUS_HT: 'HT'
    MATCH_STATUS_FT: 'FT'

    MATCH_TIMER: 'match_timer'
    MATCH_TIMER_FINISHED: ''

    EVENTS: 'match_events'
    EVENT_PLAYER: 'event_player'
    EVENT_TYPE: 'event_type'
    EVENT_TYPE_GOAL: 'goal'
    EVENT_TIME: 'event_minute'
    EVENT_TEAM: 'event_team'
    EVENT_RESULT: 'event_result'
}

.constant 'GRAPH', {
    LABEL_GAP: 5
}

.constant 'TIME', {
    INITAL_TIME: -1
    FIRSTHALF_START: 0
    FIRSTHALF_END: 45
    HALFTIME_START: 46
    HALFTIME_END: 60
    SECONDHALF_START: 61
    SECONDHALF_END: 106
    SIXTY_SECONDS : 60000
}

.constant 'URL', {
    GET_INITIAL_MATCH_INFO: 'http://localhost:8080/api/?Action=matches'
    START_SIMULATON_PREFIX: 'http://localhost:8080/api/?Action=start&matchspeed='
    GET_SIMULATON_UPDATE_PREFIX: 'http://localhost:8080/api/?Action=today&tokenId='
}

