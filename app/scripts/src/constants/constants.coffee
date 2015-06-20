angular.module 'footballAPI'

.constant 'BUTTON',
    PRE_START: 'GETTING MATCH INFORMATION'
    START: 'START'
    FINISHED: 'GAME FINISHED'
    ERROR_START: 'UNABLE TO FETCH MATCH INFORMATION - TRY LATER'
    ERROR_GAME: 'SIMULATION CANCELLED - UNABLE TO FETCH MATCH INFORMATION'

.constant 'CONFIG',
    MATCH_SPEED: 60

.constant 'DATA',
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

.constant 'GRAPH',
    LABEL_GAP: 5

.constant 'TIME',
    INITAL_TIME: -1
    FIRSTHALF_START: 0
    FIRSTHALF_END: 45
    HALFTIME_START: 46
    HALFTIME_END: 60
    SECONDHALF_START: 61
    SECONDHALF_END: 106
    SIXTY_SECONDS : 60000

.constant 'URL',
    GET_INITIAL_MATCH_INFO: 'http://104.236.187.56/api/?Action=matches'
    START_SIMULATON_PREFIX: 'http://104.236.187.56/api/?Action=start&matchspeed='
    GET_SIMULATON_UPDATE_PREFIX: 'http://104.236.187.56/api/?Action=today&tokenId='
    GITHUB_API: 'https://github.com/ollyfreeman/football-api-mock'
    GITHUB_API_README: 'http://api.github.com/repos/ollyfreeman/football-api-mock/readme'
    GITHUB_APP: 'https://github.com/ollyfreeman/football-api-app'
    LINKEDIN: 'https://www.linkedin.com/profile/view?id=217892821'
    FOOTBALL_API: 'http://www.football-api.com'

