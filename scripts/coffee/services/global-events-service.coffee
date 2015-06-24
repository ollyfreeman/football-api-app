angular.module 'footballAPI'

.factory 'GlobalEvents', [ 'Data', 'DATA', 'TIME', (Data, DATA, TIME) ->

    eventsService =
        # list of events that occur in every time slot
        globalEvents: []
        # event tooltip text
        eventTooltips:
            list: (null for [TIME.FIRSTHALF_START..TIME.SECONDHALF_END])

    eventsService.initialise = ->
        initaliseGlobalEvents()

    eventsService.addEventTooltip = (time) ->
        if eventsService.globalEvents[time]
            eventTooltipString = ''
            for event in eventsService.globalEvents[time]
                eventString = ''
                if event[DATA.EVENT_TYPE] is DATA.EVENT_TYPE_GOAL
                    eventString = "-#{event[DATA.EVENT_PLAYER]} (#{event[DATA.EVENT_TEAM]})- "
                eventTooltipString += eventString
            eventsService.eventTooltips.list[time] = eventTooltipString

    initaliseGlobalEvents = ->
        eventsService.globalEvents = Data.globalEvents

    return eventsService
]