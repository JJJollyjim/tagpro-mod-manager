mongoose = require "mongoose"
{MixType} = mongoose.models

module.exports = (req, res) ->
	MixType.find({}).populate("mixables").exec (err, mixTypes) ->
		if err # Handle error
			res.status 500
			return res.json error: "Couldn't fetch mixables"

		output = []
		typesNeeded = 0

		for type in mixTypes
			mixables = []

			typesNeeded++
			previewsNeeded = 0

			for mixable in type.mixables
				previewsNeeded++
				mixable.getPreview ((type, mixable, mixables, dataurl) ->
					previewsNeeded--
					
					if previewsNeeded is 0
						mixables.push
							preview: dataurl
							name: mixable.name
							author: mixable.author
						
						output.push
							name: type.name
							mixables: mixables

						typesNeeded--

					if typesNeeded is 0
						res.json output

				).bind this, type, mixable, mixables

			
