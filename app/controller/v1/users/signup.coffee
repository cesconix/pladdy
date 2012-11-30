module.exports = (req, res) ->
	User = db.model 'User'

	cesconix = new User
		email : 'cesconix87@gmail.com'

	cesconix.save (err) ->
		if err
			res.send err
		#Core.Logger.info "Utente creato!"
		console.log Core.L10n.__('Welcome', ['Francesco'])
		res.send Core.Response.created(cesconix)
