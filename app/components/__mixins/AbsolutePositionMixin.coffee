React = require "react/addons"
utils = require "../__utils/dom"

module.exports =
	getDefaultProps: ->
		position: 'absolute'
		placement: 'up'
		anchor: 'left'

	getInitialState: ->
		style:
			position: @props.position

	componentDidMount: ->
		@setPosition()
		window.addEventListener 'resize', @setPosition
	
	componentWillUnmount: ->
		window.removeEventListener 'resize', @setPosition

	setPosition: ->
		# nodes measurements we need to calculate position
		targetNodeWidth = @props.target.offsetWidth
		targetNodeHeight = @props.target.offsetHeight
		targetNodeOffset = utils.dom.getOffset(@props.target, @props.position)

		nodeWidth = @getDOMNode().offsetWidth
		nodeHeight = @getDOMNode().offsetHeight

		# props and states
		anchor = @props.anchor
		placement = @props.placement
		style = @state.style

		# TODO:
		# - make code more readable, use switch case

		# vertical align
		if placement is 'right' or placement is 'left'
			style.top = targetNodeOffset.top + (targetNodeHeight / 2) - (nodeHeight / 2)

		if placement is 'right'
			style.left = targetNodeWidth + targetNodeOffset.left

		if placement is 'left'
			style.left = targetNodeOffset.left - nodeWidth

		# horizontal align
		if placement is 'up' or placement is 'down'
			style.left = targetNodeOffset.left + (targetNodeWidth / 2) - nodeWidth / 2
			
			if placement is 'up'
				style.top = targetNodeOffset.top - nodeHeight
			else
				style.top = targetNodeOffset.top + targetNodeHeight

			# anchors
			if anchor is 'left'
				style.left = targetNodeOffset.left

			if anchor is 'right'
				style.left = targetNodeOffset.left - (nodeWidth - targetNodeWidth) 

		@setState
			style: style

		@adjustToViewport()

	adjustToViewport: ->
		style = @state.style

		nodeOffset =
			left: style.left
			top: style.top

		nodeWidth = @getDOMNode().offsetWidth
		nodeHeight = @getDOMNode().offsetHeight
		viewport = utils.dom.viewport()

		offsetDiff = 0

		# check if we've gone outside of the viewport (left)
		if nodeOffset.left < 0
			style['left'] = 0

		# right
		if nodeOffset.left + nodeWidth > viewport.width
			offsetDiff = viewport.width - (nodeOffset.left + nodeWidth)
			style['left'] -= -1 * offsetDiff
		
		@setState
			style: style