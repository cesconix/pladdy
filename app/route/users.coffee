{auth} = require "#{paths.CONTROLLER}/common/middleware"

#----------------
# SIGNUP
#----------------
app.post '/v:ver/users/signup', Core.Dispatcher { controller : 'users' , action : 'signup'    }
app.all  '/v:ver/users/signup', Core.Dispatcher { controller : 'common', action : 'only_post' }

#----------------
# LOGIN
#----------------
app.post '/v:ver/users/login' , Core.Dispatcher { controller : 'users' , action : 'login'     }
app.all  '/v:ver/users/login' , Core.Dispatcher { controller : 'common', action : 'only_post' }

#----------------
# LOGOUT
#----------------
app.get  '/v:ver/users/logout', [auth], Core.Dispatcher { controller : 'users' , action : 'logout' }
app.all  '/v:ver/users/logout',         Core.Dispatcher { controller : 'common', action : 'only_get' }
