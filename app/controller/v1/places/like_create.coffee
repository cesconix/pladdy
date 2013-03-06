#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api} = require "#{paths.CONTROLLER}/common/component"
_js   = require 'underscore'

module.exports =

class LikeCreate extends Api

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

			if _js.indexOf(place.likes.toString().split(','), res.locals.user._id.toString()) isnt -1
				return Response.other res, 'this user has already voted'

			place.likes.push res.locals.user
			place.save (err) ->
				if err?
					Logger.error "Places > LinkCreate: place not updated. Details: #{err}"
					return Response.server_error res, 'internal server error'

				#
				# Create Activity
				#

				activity        = new ActivityModel
				activity.verb   = 'like.place'
				activity.actor  = { type : 'user' , object : res.locals.user }
				activity.object = { type : 'place', object : place }
				activity.target = { type : 'place', object : place }
				activity.save (err) ->
					if err?
						Logger.error "Places > LikeCreate: activity not created. Details: #{err}"

				return Response.created res
