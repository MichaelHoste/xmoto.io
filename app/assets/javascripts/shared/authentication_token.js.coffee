# JQUERY

$(document).bind("ajaxSend", (elm, xhr, s) ->
  if s.type == "POST"
    csrf_token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', csrf_token)
)

# ANGULARJS

globalConfig = angular.module('GlobalConfig', [])
globalConfig.config(['$httpProvider', (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
])
