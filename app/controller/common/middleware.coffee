module.exports.auth = (req, res, next) ->

	# Check Auth
	access_token = req.query.access_token or '';

	if access_token is ''
		Response.param_error res, "missing 'access_token' parameter"
	else
		# Models
		UserModel    = db.model 'User'
		SessionModel = db.model 'Session'

		SessionModel.findOne { access_token : access_token, user_agent : req.headers['user-agent'], logout_time : null }, (err, session_result) ->
			if session_result?
				UserModel.findOne { _id : session_result.user_id }, (err, user_result) ->
					res.locals.user = user_result
					next()
			else
				Response.invalid_auth res, 'access_token invalid or revoked'

module.exports.secure = (req, res, next) ->
	if app.get('env') is 'development'
		return next()

	if req.headers['x-forwarded-proto'] is 'https'
		next()
	else
		Response.endpoint_error res, 'all api requests must be sent over https'

module.exports.uploader = (req, res, next) ->
	console.log req.files
	next()

module.exports.basicAuth = require('express').basicAuth (user, pass) ->
	params = app.get 'basicAuth'
	user is params.username and pass is params.password
, app.get 'app title'
