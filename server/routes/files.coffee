module.exports = (req, res) ->
	if req.params.id is "5292f07824c79b0b50000001" or req.params.id is "vanilla"
		return res.json {}

	if filestore?
		# Connected to filestore
		
		filestore.getFileURLs req.params.id, (err, urls) ->
			if err
				res.status 404
				return res.json
					error: "Couldn't find files for given mod id"

			basicURLs = {}
			for name, info of urls
				basicURLs[name] = info.url

			res.json basicURLs
	else throw new Error "Not connected to Filestore"