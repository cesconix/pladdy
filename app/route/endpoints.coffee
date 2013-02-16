{basicAuth} = require "#{paths.CONTROLLER}/common/middleware"

app.all '/endpoints', [basicAuth], Core.Dispatcher { controller : 'common', action : 'endpoints' }
