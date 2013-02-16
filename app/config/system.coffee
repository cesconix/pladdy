module.exports = () ->

	app.set 'server name'    , 'api.pladdy.com'
	app.set 'server website' , "https://#{app.get 'server name'}/"

	app.set 'system port'    , 8080
	app.set 'json spaces'    , if app.get('env') is 'production' then 0 else 2
	app.set 'security salt'  , 'DYhG93b0qyJfIxfs2guVoUubWwvniR2G0FgaC9mi'

	app.set 'view engine'    , 'jade'
	app.set 'views'          , "#{paths.VIEW}"

	app.enable 'strict routing'
	app.enable 'case sensitive routing'

	app.set 'email',
		transport:
			type    : 'SMTP'
			options :
				secureConnection : true
				host : "smtpout.europe.secureserver.net"
				port : 465
				auth :
					user: "notifier@pladdy.com",
					pass: "ciccionix"

	app.set 'basicAuth'
		username : 'cesconix'
		password : 'nodejs'
