module.exports = () ->

	app.set 'server name'    , 'api.pladdy.com'
	app.set 'server website' , "http://#{app.get 'server name'}/"

	app.set 'system port'    , 8080
	app.set 'json spaces'    , 2
	app.set 'security salt'  , 'DYhG93b0qyJfIxfs2guVoUubWwvniR2G0FgaC9mi'

	app.set 'view engine'    , 'jade'
	app.set 'views'          , "#{paths.VIEW}"

	app.set 'email',
		transport:
			type    : 'SMTP'
			options :
				service : 'Gmail'
				auth    :
					user : "pladdy.com@gmail.com",
					pass : "[@cesconix#]"

	app.enable 'strict routing'
	app.enable 'case sensitive routing'
