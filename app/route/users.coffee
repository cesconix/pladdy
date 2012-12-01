{auth} = require "#{paths.CONTROLLER}/common/middleware"

app.post '/v:ver/users/signup', Core.Dispatcher { controller : 'users', action : 'signup' }
