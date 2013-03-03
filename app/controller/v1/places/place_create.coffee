#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api} = require "#{paths.CONTROLLER}/common/component"
_js   = require 'underscore'

module.exports =

class PlaceCreate extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			lat  : { required : yes }
			lng  : { required : yes }
			type : { required : yes, values : ['love', 'vendor'] }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		ActivityModel = db.model 'Activity'

		where =
			type : @data.type
			loc  :
				$near        : [ @data.lat, @data.lng ]
				$maxDistance : app.get('app settings').maxDistance

		PlaceModel.find where, (err, results) =>

			# clone results
			places = results.slice()

			# create new place
			place      = new PlaceModel
			place.type = @data.type
			place.loc  = [@data.lat, @data.lng]

 			# insert this new place in clone results
			places.push place

			merged = no
			places_removed = []

			# calculation of the average distance between the points
			while (places.length > 1)

				merged = yes

				# create new place place from the merge data of the first 2 places
				new_place = @merge places[0], places[1]

				places_removed.push places[0], places[1]

				# delete first 2 places found
				places.splice 0, 2

				# save new place in head of the clone results
				places.unshift new_place

			# delete all places from db
			for result in results
				result.remove()

			# add new place
			if places.length is 1
				p          = new PlaceModel
				p.type     = @data.type
				p.loc      = [ places[0].loc[0], places[0].loc[1] ]
				p.ranking  = places[0].ranking
				p.likes    = places[0].likes
				p.tips     = places[0].tips
				p.checkins = places[0].checkins
				p.save (err) ->
					if err?
						Logger.error err

					if merged
						ActivityModel.update { 'actor.type' : 'place', 'actor.object': { $in : places_removed } }, { 'actor.object' : p }, (err, numberAffected, raw) ->
							if err?
								Logger.error err

						ActivityModel.update { 'object.type' : 'place', 'object.object': { $in : places_removed } }, { 'object.object' : p }, (err, numberAffected, raw) ->
							if err?
								Logger.error err

						ActivityModel.update { 'target.type' : 'place', 'target.object': { $in : places_removed } }, { 'target.object' : p }, (err, numberAffected, raw) ->
							if err?
								Logger.error err
					else
						activity               = new ActivityModel
						activity.actor.type    = 'user'
						activity.actor.object  = res.locals.user._id
						activity.verb          = 'place'
						activity.object.type   = 'place'
						activity.object.object = p
						activity.target.type   = 'place'
						activity.target.object = p
						activity.save (err) ->
							if err?
								Logger.error err

					return Response.created res, p

	merge: (p1, p2) ->
		PlaceModel    = db.model 'Place'

		lat = ( (p1.ranking * p1.loc[0]) + (p2.ranking * p2.loc[0]) ) / (p1.ranking + p2.ranking)
		lng = ( (p1.ranking * p1.loc[1]) + (p2.ranking * p2.loc[1]) ) / (p1.ranking + p2.ranking)
		rnk = p1.ranking + p2.ranking

		place          = new PlaceModel
		place.type     = p1.type
		place.loc      = [ lat, lng ]
		place.ranking  = rnk
		place.likes    = _js.union p1.likes   , p2.likes
		place.tips     = _js.union p1.tips    , p2.tips
		place.checkins = _js.union p1.checkins, p2.checkins

		return place
