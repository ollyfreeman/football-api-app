angular.module 'footballAPI'

.factory('Graph', [ 'Labels', 'PlayerScore', (Labels, PlayerScore) ->

    graphService = {}

    graphService.data = []
    graphService.labels = Labels.graphLabels

    graphService.initialise = () ->
        graphService.data.push(PlayerScore.playerScore)

    return graphService
])