chrome.storage.local.get "files", (vals) ->
	# alert "Got stuff"
	files = vals.files
	console.log files

	fileTypes = ["tiles", "splats", "flair", "speedpad"]

	for type in fileTypes
		console.log "? #{type}"
		if type of files
			console.log "Do #{type}"
			document.getElementById(type).src = files[type]