{secure, auth} = require "#{paths.CONTROLLER}/common/middleware"

app.post '/v:ver/places', [secure, auth], Core.Dispatcher { controller : 'places' , action : 'place_create' }
app.get  '/v:ver/places', [secure, auth], Core.Dispatcher { controller : 'places' , action : 'place_read'   }
