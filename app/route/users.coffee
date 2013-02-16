{secure, auth, uploader} = require "#{paths.CONTROLLER}/common/middleware"

#----------------
# SIGNUP
#----------------
app.post '/v:ver/users/signup', [secure], Core.Dispatcher { controller : 'users' , action : 'signup'    }
app.all  '/v:ver/users/signup', [secure], Core.Dispatcher { controller : 'common', action : 'only_post' }

#----------------
# RECOVER
#----------------
app.post '/v:ver/users/recover', [secure], Core.Dispatcher { controller : 'users' , action : 'recover'   }
app.all  '/v:ver/users/recover', [secure], Core.Dispatcher { controller : 'common', action : 'only_post' }

#----------------
# PASSWORD RESET
#----------------
app.post '/v:ver/users/password_reset/:hash_user/:hash_expiry', [secure], Core.Dispatcher { controller : 'users' , action : 'password_reset' }
app.all  '/v:ver/users/password_reset/:hash_user/:hash_expiry', [secure], Core.Dispatcher { controller : 'common', action : 'only_post'      }

#----------------
# LOGIN
#----------------
app.post '/v:ver/users/login' , [secure], Core.Dispatcher { controller : 'users' , action : 'login'     }
app.all  '/v:ver/users/login' , [secure], Core.Dispatcher { controller : 'common', action : 'only_post' }

#----------------
# LOGOUT
#----------------
app.get  '/v:ver/users/logout', [secure, auth], Core.Dispatcher { controller : 'users' , action : 'logout'   }
app.all  '/v:ver/users/logout', [secure]      , Core.Dispatcher { controller : 'common', action : 'only_get' }

#----------------
# SELF
#----------------
app.get  '/v:ver/users/self'  , [secure, auth]          , Core.Dispatcher { controller : 'users' , action : 'profile_read'   }
app.put  '/v:ver/users/self'  , [secure, auth, uploader], Core.Dispatcher { controller : 'users' , action : 'profile_update' }
