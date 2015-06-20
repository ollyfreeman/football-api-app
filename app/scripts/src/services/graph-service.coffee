angular.module 'footballAPI'

.factory 'Graph', [ 'Labels', 'PlayerScore', (Labels, PlayerScore) ->

    graphService =
        data: []
        labels: Labels.graphLabels

    graphService.initialise = ->
        graphService.data.push PlayerScore.playerScore

    return graphService
]