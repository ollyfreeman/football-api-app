angular.module 'footballAPI'

.controller 'ApiTabContentController', [ '$http', '$sce', 'URL', ($http, $sce, URL) ->
    ctrl = @

    ctrl.content = 'Loading...'
    ctrl.footballApiURL = URL.FOOTBALL_API
    ctrl.githubApiURL = URL.GITHUB_API

    $http.get URL.GITHUB_API_README
    .success (data, status) ->
        # decode the content attribute of the response
        content = atob data.content
        # convert from markdown to html
        content = markdown.toHTML content

        ctrl.content = $sce.trustAsHtml content
    .error (data, status) ->
        ctrl.content = 'Error loading README'

    return ctrl
]