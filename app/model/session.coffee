{Schema} = require 'mongoose'

name = 'Session'

schema = new Schema({

	user_id:
		type     : Schema.Types.ObjectId
		ref      : 'User'
		required : yes

	login_time:
		type    : Date
		default : new Date()

	last_login:
		type    : Date
		default : new Date()

	logout_time:
		type    : Date

	user_agent:
		type     : String
		required : yes

	access_token:
		type     : String
		required : yes
		unique   : yes

},{
	versionKey : no
})

module.exports.name   = name
module.exports.schema = schema
