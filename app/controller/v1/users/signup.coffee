{Email} = require "#{paths.CONTROLLER}/common/component"

module.exports = (req, res) ->

	email = new Email({
		template : 'signup'
		to       : '"Francesco Pasqua" <cesconix87@gmail.com>'
		subject  : __('Conferma il tuo account %s, %s!', [app.get('app title'), 'cesconix'])
	}, {
		title : __('Conferma il tuo account %s, %s!', [app.get('app title'), 'cesconix'])
		name : 'Francesco Pasqua'
		link : 'http://pladdy.com/hash'
	})

	email.send (err) ->
		console.log err

	Core.Response.ok res, {}
