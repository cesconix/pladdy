#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema}   = require 'mongoose'
{validate} = require 'mongoose-validator'

name = 'Tip'

schema = new Schema({

	text:
		type     : String
		required : yes
		validate : [
			validate message : __('min 20, max 200 characters'), 'len', 20, 200
		]

	likes: [{
		type    : Schema.Types.ObjectId
		ref     : 'User'
	}]

	created:
		type     : Date
		default  : Date.now

	modified:
		type     : Date

},{
	versionKey : no
})

module.exports.name   = name
module.exports.schema = schema
