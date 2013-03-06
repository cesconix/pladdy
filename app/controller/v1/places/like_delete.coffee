#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api} = require "#{paths.CONTROLLER}/common/component"
_js   = require 'underscore'

module.exports =

class LikeDelete extends Api

	constructor: ->
		super

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		ActivityModel = db.model 'Activity'

		PlaceModel.findOne { _id : @data.place_id }, (err, place) ->

			if not place?
				return Response.endpoint_error res, 'place not found'

			if _js.indexOf(place.likes.toString().split(','), res.locals.user._id.toString()) is -1
				return Response.other res, 'this user has not rated this place'

			place.likes.pull res.locals.user
			place.save (err) ->
				if err?
					Logger.error "LikeDelete: place not updated. Details: #{err}"
					return Response.server_error res, 'internal server error'

				#
				# Delete Activity
				#

				removeConditions =
					'actor.object'  : res.locals.user
					'verb'          : 'like.place'
					'object.object' : place

				ActivityModel.findOneAndRemove removeConditions, (err) ->
					if err?
						Logger.error "LikeDelete: activity not removed. Details: #{err}"

				return Response.ok res
