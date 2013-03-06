{secure, auth} = require "#{paths.CONTROLLER}/common/middleware"

app.get  '/v:ver/users/self/activities', [secure, auth], Core.Dispatcher controller : 'activities' , action : 'activities_read'
app.all  '/v:ver/users/self/activities', [secure]      , Core.Dispatcher controller : 'common'     , action : 'only_get'
