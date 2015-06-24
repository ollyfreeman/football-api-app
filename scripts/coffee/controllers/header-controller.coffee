angular.module 'footballAPI'

.controller 'HeaderController', ['URL', (URL) ->
    ctrl = @

    ctrl.githubURL = URL.GITHUB_APP
    ctrl.linkedInURL = URL.LINKEDIN

    return ctrl
]