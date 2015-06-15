angular.module 'footballAPI'

.controller('HeaderController', ['URL', (URL) ->
    ctrl = this

    ctrl.githubURL = URL.GITHUB_APP
    ctrl.linkedInURL = URL.LINKEDIN

    return ctrl
])