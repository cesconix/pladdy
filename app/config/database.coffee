module.exports = (app) ->

	app.set 'databases',

		production :
			host : 'alex.mongohq.com'
			port : 10026
			name : 'nodejitsudb4277599164'
			user : 'nodejitsu'
			pass : '86442b8e34b4cb36aaa3d83e1e338561'

		development :
			host : 'alex.mongohq.com'
			port : 10021
			name : 'nodejitsudb993625964367'
			user : 'nodejitsu'
			pass : 'ee8ffb9b445aff2d0d782d58ed03581a'
