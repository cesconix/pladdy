#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema} = require 'mongoose'

name = 'Session'

schema = new Schema({

	user_id:
		type     : Schema.Types.ObjectId
		ref      : 'User'
		required : yes

	login_time:
		type    : Date
		default : Date.now

	last_login:
		type    : Date
		default : Date.now

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
