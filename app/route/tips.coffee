{secure, auth} = require "#{paths.CONTROLLER}/common/middleware"

app.get    '/v:ver/places/:place_id/tips'        , [secure, auth], Core.Dispatcher controller : 'tips'  , action : 'tips_read'
app.post   '/v:ver/places/:place_id/tips'        , [secure, auth], Core.Dispatcher controller : 'tips'  , action : 'tip_create'
app.all    '/v:ver/places/:place_id/tips'        , [secure]      , Core.Dispatcher controller : 'common', action : 'verb_not_supported'

app.get    '/v:ver/places/:place_id/tips/:tip_id', [secure, auth], Core.Dispatcher controller : 'tips'  , action : 'tip_read'
app.put    '/v:ver/places/:place_id/tips/:tip_id', [secure, auth], Core.Dispatcher controller : 'tips'  , action : 'tip_update'
app.delete '/v:ver/places/:place_id/tips/:tip_id', [secure, auth], Core.Dispatcher controller : 'tips'  , action : 'tip_delete'
app.all    '/v:ver/places/:place_id/tips/:tip_id', [secure]      , Core.Dispatcher controller : 'common', action : 'verb_not_supported'
