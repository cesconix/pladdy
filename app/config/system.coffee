module.exports = (app) ->

	app.set 'system port'  , 8080
	app.set 'json spaces'  , 2
	app.set 'security salt', 'DYhG93b0qyJfIxfs2guVoUubWwvniR2G0FgaC9mi'

	app.enable 'strict routing'
	app.enable 'case sensitive routing'
