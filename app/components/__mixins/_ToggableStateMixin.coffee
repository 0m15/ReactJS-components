ToggableStateMixin = PopoverStateMixin = DropdownStateMixin =
	getInitialState: ->
		open: false

	bindCloseHandler: ->
		document.addEventListener 'keyup', @handleKeyup

		# handle click outside event
		if @props.autoClose
			document.addEventListener 'click', @handleClickOutside
			
	unbindCloseHandler: ->
		document.removeEventListener 'keyup', @handleKeyup

		if @props.autoClose
			document.removeEventListener 'click', @handleClickOutside
			

	handleClickOutside: (e) ->
		@setState
			open: false
		@unbindCloseHandler()

	handleKeyup: (e) ->
		if e.keyCode is 27
			@setState
				open: false
		@unbindCloseHandler()

	handleToggle: (e) ->
		e.preventDefault()
		open = !@state.open

		@setState
			open: open

		if open is true
			@bindCloseHandler()
		else
			@unbindCloseHandler()