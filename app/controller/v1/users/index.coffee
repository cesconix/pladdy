#----------------
# Users
#----------------

[
	  'signup'
	, 'recover'
	, 'login'
	, 'logout'
    , 'password_reset'
    , 'profile_read'
    , 'profile_update'

].map (api) ->
	module.exports[api] = (req, res) ->
		Api = new (require "./#{api}")
		Api.exec req, res
