React = require "react/addons"

# used to store a __stack__ of toggable elements
# to keep track of the hierarchy
__stack = []

module.exports =
	getInitialState: ->
		open: false

	componentWillUnmount: ->
		@unbindCloseHandler()

	bindCloseHandler: ->
		document.addEventListener 'keyup', @handleKeyup
			
	unbindCloseHandler: ->
		document.removeEventListener 'keyup', @handleKeyup
			
	handleClickInside: (e) ->
		e.stopPropagation()
		e.preventDefault()

	handleClickOutside: (e) ->
		e.preventDefault()
		e.stopPropagation()

		@close()

	handleKeyup: (e) ->
		current = __stack[__stack.length-1]

		if e.keyCode is 27
			current.close()

	handleToggle: (e) ->
		e.preventDefault()
		e.stopPropagation()

		if @state.open is true
			@close()
		else
			@open()

	#
	# APIs
	#

	open: ->
		__stack.push @

		@setState
			open: true
		@bindCloseHandler()

	close: ->
		idx = __stack.indexOf @
		__stack.splice(idx, 1)

		@setState
			open: false
		@unbindCloseHandler()