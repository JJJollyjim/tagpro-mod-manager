module.exports =
	enc: (imgbuffer) ->
		"data:image/png;base64," + imgbuffer.toString("base64")

	dec: (imgstring) ->
		new Buffer(
			imgstring.replace(/data:image\/png;[a-z=;]*base64,/, "")
			, "base64"
		)