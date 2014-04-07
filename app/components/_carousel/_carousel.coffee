classSet = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
ReactTransitionGroup = React.addons.TransitionGroup
PropTypes = React.PropTypes

CarouselStateMixin = 
	propTypes:
		items: PropTypes.array
		itemComponent: PropTypes.component

	getInitialState: ->
		index: 0
		activeItems: @props.items[0...1]
		direction: 'forward'

	setActiveItem: (index, direction) ->
		newItem = @props.items[index]
		newItems = @state.activeItems

		newItems.pop()
		newItems.unshift(newItem)

		@setState
			index: index
			activeItems: newItems
			direction: direction

	handleNext: (e) ->
		e.preventDefault()

		index = @state.index
		index += 1
		
		if index == @props.items.length
			index = 0

		@setActiveItem index, 'forward'

	handlePrevious: (e) ->
		e.preventDefault()

		index = @state.index
		index -= 1
		
		if index < 0
			index = @props.items.length - 1

		@setActiveItem index, 'backward'

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
	propTypes:
		item: PropTypes.object
		itemComponent: PropTypes.component
		#active: PropTypes.boolean

	render: ->

		classes = classSet
			'carousel-item': true
			active: @props.active
		
		`<div className={classes}>
			{this.props.itemComponent({item: this.props.item})}
		</div>`

Carousel = React.createClass
	mixins: [CarouselStateMixin]

	render: ->		
		self = @
		children = @state.activeItems.map (item, i) ->
			`<CarouselItem
				item={item} 
				key={item.key} 
				active={i==self.state.index}
				itemComponent={self.props.itemComponent}
			/>`
		
		`<div className={"carousel " + this.state.direction}>
			<ReactCSSTransitionGroup transitionName='slide'>
				{children}
			</ReactCSSTransitionGroup>
			<CarouselControls onNext={this.handleNext} onPrevious={this.handlePrevious}/>
		</div>`