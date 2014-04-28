`/** @jsx React.DOM */`

React = require "react/addons"

classSet = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
ReactTransitionGroup = React.addons.TransitionGroup
PropTypes = React.PropTypes

CarouselControls = React.createClass
	propTypes:
		onNext: PropTypes.func
		onPrevious: PropTypes.func

	render: ->
		`<div className="carousel-controls">
				<a href="" onClick={this.handlePrevious}>prev</a> 
				<a href="" onClick={this.handleNext}>next</a>
		</div>`

	handleNext: (e) ->
		@props.onNext(e)

	handlePrevious: (e) ->
		@props.onPrevious(e)

CarouselItem = React.createClass
	getInitialState: ->
		classes:
			'carousel-item': true
		style:
			'margin-left': 0

	propTypes:
		item: PropTypes.object
		itemComponent: PropTypes.component

	componentDidMount: ->
		@setup()

	setup: ->
		@reflow()
		self = @
		# inform parent child completed transition, a.k.a. "onSlide"
		$(@getDOMNode()).on 'transitionend MSTransitionEnd webkitTransitionEnd oTransitionEnd', ->
			self.props.onSlide()

	reflow: ->
		el = @getDOMNode()
		elWidth = $(el).width()
		left = (@props.index - 1) * elWidth
		style = @state.style
		style.left = left + 'px'

		@setState
			style: style

	render: ->
		classes = classSet @state.classes
		style = @state.style

		`<div className={classes} style={style}>
			{this.props.itemComponent({item: this.props.item})}
		</div>`

Carousel = React.createClass
	propTypes:
		items: PropTypes.array
		itemComponent: PropTypes.component

	getInitialState: ->
		index: 0
		activeItems: @props.items
		direction: 'forward'
		sliding: false
		enabled: false

	componentDidMount: () ->
		@setup()
		self = @
		$(window).on 'resize', @handleWindowResize

	_getViewportWidth: () ->
		$(@getDOMNode()).width()		

	_getSlides: ->
		$(@getDOMNode()).find '.carousel-item'
	
	_getSlidesActualWidth: (index) ->
		index = @state.index if not index?
		totalWidth = 0
		$item = null

		@_getSlides().slice(index).each -> 
			$item = $(this)
			totalWidth += $item.width()
		return totalWidth

	setup: ->
		self = this
		itemsWidth = 0
		viewportWidth = @_getViewportWidth()

		# check total width
		itemsWidth = @_getSlidesActualWidth(0)

		# enable/disable carousel
		enabled = itemsWidth > viewportWidth			
		
		@setState
			enabled: enabled

	reset: ->
		@_getSlides().each ->
			$(this).css('margin-left', 0)

	hasNext: ->
		viewportWidth = @_getViewportWidth()
		totalWidth = @_getSlidesActualWidth()
		return totalWidth > viewportWidth

	hasPrevious: ->
		return parseInt(@_getSlides()[0].style['margin-left']) < 0

	nextSlide: ->
		index = @state.index
		index += 1
		
		if index is @props.items.length
			index = @props.items.length

		@slideTo index, 'forward'		

	previousSlide: ->
		index = @state.index
		index -= 1
		
		if index < 0
			index = 0

		@slideTo index, 'backward'

	slideTo: (index, direction) ->
		# TODO: 
		# - convert all declarative styles to @setStyle fn call on <CarouselItem>
		if not @state.enabled
			return false

		if direction is 'forward' and not @hasNext()
			return false

		if direction is 'backward' and not @hasPrevious()
			return false

		if @state.sliding
			return false

		self = @
		exceedingWidth = 0
		newOffset = 0
		sliding = true

		$items = @_getSlides()
		$item = $items.first()

		itemWidth = $item.width()
		lastOffsetLeft = parseInt $item.css('margin-left').replace('px', '')
		offsetLeft = index * itemWidth
		
		if direction is 'backward'
			newOffset = lastOffsetLeft + $item.width()
			
			# offset wasn't a multiple of the element width
			if lastOffsetLeft % itemWidth != 0
				newOffset = (lastOffsetLeft - newOffset)

			if lastOffsetLeft is 0
				index = 0
				newOffset = 0
				sliding = false

		else
			newOffset = lastOffsetLeft - $item.width()

			# exceeding width is less than item width
			exceedingWidth = self._getSlidesActualWidth() - self._getViewportWidth()
			
			if exceedingWidth < $item.width()
				newOffset = lastOffsetLeft - exceedingWidth

		@setState
			index: index
			direction: direction
			sliding: sliding

		$items.css('margin-left', newOffset)

	handleOnSlide: ->
		@setState
			sliding: false

	handleNext: (e) ->
		e.preventDefault()
		@nextSlide()

	handlePrevious: (e) ->
		e.preventDefault()
		@previousSlide()

	handleWindowResize: (e) ->
		@setup()
		self = @

		# reflow items
		@state.activeItems.forEach (item) ->
			ref = self.refs["item#{item.key}"]
			ref.reflow()

	render: ->	
		self = @
		children = @state.activeItems.map (item, i) ->
			`<CarouselItem
				item={item}
				index={item.key}
				currentIndex={self.state.index}
				key={item.key}
				direction={self.state.direction}
				active={i==self.state.index}
				itemComponent={self.props.itemComponent}
				ref={'item'+item.key}
				onSlide={self.handleOnSlide}
			/>`
		
		`<div className={"carousel " + this.state.direction}>
				{children}
			<CarouselControls enabled={this.state.enabled} onNext={this.handleNext} onPrevious={this.handlePrevious}/>
		</div>`

module.exports = Carousel