# tpmmServer = "http://localhost:5000"
tpmmServer = "http://tagpro-mod-manager.herokuapp.com"

qwest.get("#{tpmmServer}/mods").success ->
	mods = this.response

	loader = document.getElementById "loader"
	ul = document.getElementById "mods"

	chrome.storage.local.get "sid", (vals) ->
		loader.style.display = "none"
		sid = vals.sid

		for mod in mods
			# LI
			li = document.createElement "li"
			li.dataset.modid = if mod._id isnt "5292f07824c79b0b50000001" then mod._id else "vanilla"

			if sid == li.dataset.modid
				li.className = "mod sidmatch"
			else
				li.className = "mod"

			ul.appendChild li

			# Title & author
			div = document.createElement "div"
			div.className = "modinfo"

			title = document.createElement "div"
			title.className = "modtitle"
			div.appendChild title
			title_text = document.createTextNode mod.name
			title.appendChild title_text

			author = document.createElement "div"
			author.className = "modauthor"
			div.appendChild author
			author_text = document.createTextNode "By #{mod.author}"
			author.appendChild author_text

			li.appendChild div

			# Image
			img = document.createElement "img"
			img.src = mod.thumbnail
			li.appendChild img
			
			# Click listener
			li.addEventListener "click", ->
				loader.style.display = "block"

				qwest.get("#{tpmmServer}/files/#{@dataset.modid}").success (data) =>
					chrome.storage.local.set {sid: @dataset.modid, files: data.files}, =>
						for ele in document.getElementsByClassName "sidmatch"
							ele.className = "mod"

						@className = "mod sidmatch"
						loader.style.display = "none"
						
						alert "Mod installed!"