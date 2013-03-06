{secure, auth} = require "#{paths.CONTROLLER}/common/middleware"

app.post   '/v:ver/places'                , [secure, auth], Core.Dispatcher controller : 'places' , action : 'place_create'
app.get    '/v:ver/places'                , [secure, auth], Core.Dispatcher controller : 'places' , action : 'place_read'
app.all    '/v:ver/places'                , [secure]      , Core.Dispatcher controller : 'common' , action : 'verb_not_supported'

app.post   '/v:ver/places/:place_id/likes', [secure, auth], Core.Dispatcher controller : 'places' , action : 'like_create'
app.delete '/v:ver/places/:place_id/likes', [secure, auth], Core.Dispatcher controller : 'places' , action : 'like_delete'
app.all    '/v:ver/places/:place_id/likes', [secure]      , Core.Dispatcher controller : 'common' , action : 'verb_not_supported'
