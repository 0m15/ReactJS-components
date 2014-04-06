AbsolutePositionMixin =
	getInitialState: ->
		style:
			position: 'absolute'

	componentDidMount: ->
		@setPosition()

		# handle window resize event
		$(window).on 'resize', @setPosition
			
	setPosition: ->
		# refs to nodes
		$btnEl = $(@refs.button.getDOMNode())
		$contentEl = $(@refs.menu.getDOMNode())

		# nodes measurements we need to calculate position
		btnWidth = $btnEl.width()
		btnHeight = $btnEl.height()
		btnOffset = $btnEl.offset()
		contentElWidth = $contentEl.width()
		contentElHeight = $contentEl.height()

		# props and states
		anchor = @props.anchor
		placement = @props.placement
		style = @state.style

		# vertical align
		if placement is 'right' or placement is 'left'
			style.top = btnOffset.top + (btnHeight / 2) - (contentElHeight / 2)

		if placement is 'right'
			style.left = btnWidth + btnOffset.left

		if placement is 'left'
			style.left = btnOffset.left - contentElWidth

		# horizontal align
		if placement is 'up' or placement is 'down'
			style.left = btnOffset.left + (btnWidth / 2) - contentElWidth / 2

			# anchors
			if anchor is 'left'
				style.left = btnOffset.left

			if anchor is 'right'
				style.left = btnOffset.left - (contentElWidth - btnWidth) 

		if placement is 'up'
			style.top = btnOffset.top - contentElHeight


		@setState
			style: style

		@adjustToViewport()

	adjustToViewport: ->
		# TODO: 
		# - refactor this
		# - convert `margin-left` to absolute `left` and `right` positions
		# - check for `top` and `bottom` boundings
		$dropdownEl = $(@refs.menu.getDOMNode())
		dropdownMarginRight = parseInt $dropdownEl.css('margin-right')
		dropdownLeftOffset = $(@refs.button.getDOMNode()).offset().left
		dropdownWidth = $dropdownEl.width()
		style = @state.style
		winWidth = $(window).width()
		offsetDiff = 0

		# check if we've gone outside of the viewport (left)
		if dropdownLeftOffset < 0 || $dropdownEl.offset().left < 0
			offsetDiff = dropdownMarginRight - (-dropdownLeftOffset)
			if @props.placement is 'right'
				style['margin-right'] = 0
				style['left'] = 0
			else
				style['margin-left'] = 0
				style['left'] = 0

		# right
		if dropdownLeftOffset + dropdownWidth > winWidth
			offsetDiff = (dropdownLeftOffset + $dropdownEl.width()) - winWidth
			style.left = -1 * offsetDiff + 'px'

		# todo: top|bottom
		
		@setState
			style: style