#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

module.exports.compactObject = (type, object) ->

	switch type

		when 'user'

			compact =
				username : object.username
				profile  : object.profile

		when 'place'

			compact =
				_id      : object._id
				type     : object.type
				coords   : { lat : object.loc[0], lng : object.loc[1] }
				likes    : { count : object.likes.length }
				tips     : { count : object.tips.length }
				checkins : { count : object.checkins.length }
				ranking  : object.ranking

		when 'tip'

			compact =
				_id     : object._id
				text    : object.text
				likes   : { count : object.likes.length }
				created : object.created.getTime()

			if object.modified?
				compact.modified = object.modified.getTime()

	return {
		type   : type
		object : compact
	}
