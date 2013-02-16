{basicAuth} = require "#{paths.CONTROLLER}/common/middleware"

app.all '/v:ver/*', Core.Dispatcher { controller : 'common', action : 'endpoint_error' }
app.all '/v:ver/' , Core.Dispatcher { controller : 'common', action : 'endpoint_error' }

app.all '/v:ver'  , [basicAuth], Core.Dispatcher { controller : 'common', action : 'not_found'      }
app.all '/'       , [basicAuth], Core.Dispatcher { controller : 'common', action : 'home'           }
app.all '*'       , [basicAuth], Core.Dispatcher { controller : 'common', action : 'not_found'      }
