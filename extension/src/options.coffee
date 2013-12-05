file_data = {}
to_read = 0

Object.size = (obj) ->
	size = 0
	for own k of obj
		size++
	size

$(".upload-file").each ->
	this.addEventListener "change", (e) ->
		e.stopPropagation()
		e.preventDefault()

		if e.target.files.length is 1
			file = e.target.files[0]

			if file.type isnt "image/png"
				alert "Error: #{@id} isn't a PNG!"
				throw new Error

			reader = new FileReader

			reader.onload = (e) =>
				file_data[@id] = e.target.result
				to_read--

				console.log "Loaded #{@id}"

			to_read++
			reader.readAsDataURL(file)

		else
			console.error "Error handling #{@id}"
			delete file_data[@id]

submit_files = ->
	if to_read isnt 0
		console.log "Not all read, delaying…"
		setTimeout submit_files, 200
		return

	if Object.size file_data is 0
		return alert("You must add one or more files")

	chrome.storage.local.set {sid: "test", files: file_data}, ->
		alert "Your mod is now installed!"

$("#submit").click submit_files