Mod = require("mongoose").models.Mod

module.exports = (req, res) ->
	if req.params.id is "5292f07824c79b0b50000001" or req.params.id is "vanilla"
		return res.json {
			_id: "vanilla"
			files: {}
		}

	Mod.findById req.params.id, "files", (err, files) ->
		if err
			res.status 404
			return res.json error: "Couldn't find files for given mod id"

		res.json files