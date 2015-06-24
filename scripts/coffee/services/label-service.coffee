angular.module 'footballAPI'

.factory 'Labels', [ 'GRAPH', 'TIME', (GRAPH, TIME) ->

    labelService = {}

    # labels for angular-chart
    labelService.graphLabels = []
    for i in [TIME.FIRSTHALF_START..TIME.SECONDHALF_END]
        labelService.graphLabels.push ''
    for i in[TIME.FIRSTHALF_START..TIME.FIRSTHALF_END - 1] by GRAPH.LABEL_GAP
        labelService.graphLabels[i] = "#{i} FH"
    for i in[TIME.HALFTIME_START..TIME.HALFTIME_END] by GRAPH.LABEL_GAP
        labelService.graphLabels[i] = "#{i-TIME.HALFTIME_START} HT"
    for i in[TIME.SECONDHALF_START..TIME.SECONDHALF_END] by GRAPH.LABEL_GAP
        labelService.graphLabels[i] = "#{i-(TIME.SECONDHALF_START-TIME.FIRSTHALF_END)} SH"

    # time labels for tooltips
    labelService.tooltipLabels = []
    for i in[TIME.FIRSTHALF_START..TIME.FIRSTHALF_END]
        labelService.tooltipLabels[i] = "#{i} FH"
    for i in[TIME.HALFTIME_START..TIME.HALFTIME_END]
        labelService.tooltipLabels[i] = "#{i-TIME.HALFTIME_START} HT"
    for i in[TIME.SECONDHALF_START..TIME.SECONDHALF_END]
        labelService.tooltipLabels[i] = "#{i-(TIME.SECONDHALF_START-TIME.FIRSTHALF_END)} SH"

    return labelService
]