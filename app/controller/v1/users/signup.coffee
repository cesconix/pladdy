module.exports = (req, res) ->
	User = db.model 'User'

	cesconix = new User
		email : 'cesconix87@gmail.com'

	cesconix.save (err) ->
		if err
			res.send err
		res.send cesconix
