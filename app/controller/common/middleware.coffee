module.exports.auth = (req, res, next) ->

	# Check Auth
	access_token = req.query.access_token or '';

	if access_token is ''
		Response.param_error res, "missing 'access_token' parameter"
	else
		# Models
		SessionModel = db.model 'Session'

		SessionModel.findOne { access_token : access_token, user_agent : req.headers['user-agent'], logout_time : null }, (err, session_result) ->
			if session_result?
				next()
			else
				Response.invalid_auth res, 'access_token invalid or revoked'
