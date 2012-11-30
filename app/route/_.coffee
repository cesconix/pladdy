app.all '/v:ver/*', Core.Dispatcher { controller : 'common', action : 'endpoint_error' }
app.all '/v:ver'  , Core.Dispatcher { controller : 'common', action : 'not_found'      }
app.all '/'       , Core.Dispatcher { controller : 'common', action : 'home'           }
app.all '*'       , Core.Dispatcher { controller : 'common', action : 'not_found'      }
