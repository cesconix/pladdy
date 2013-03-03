#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema}   = require 'mongoose'
{validate} = require 'mongoose-validator'

name = 'Checkin'

schema = new Schema({

	text:
		type     : String
		required : yes
		validate : [
			validate message : __('max 200 characters'), 'len', 1, 200
		]

	likes: [{
		type    : Schema.Types.ObjectId
		ref     : 'User'
	}]

	comments: [{
		type    : Schema.Types.ObjectId
		ref     : 'Comment'
	}]

	created:
		type     : Date
		default  : Date.now

},{
	versionKey : no
})

module.exports.name   = name
module.exports.schema = schema
