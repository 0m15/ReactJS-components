# `/** @jsx React.DOM */`


classSet = React.addons.classSet

PopoverButton = React.createClass
	mixins: [ToggableStateMixin, AbsolutePositionMixin]

	render: ->
		classes = classSet
			open: @state.open
			popover: true

		`<div className={classes}>
			<a href="" onClick={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<PopoverPanel ref="menu" style={this.state.style}>{this.props.children}</PopoverPanel>
		</div>
		`
PopoverPanel = React.createClass
	render: ->
		`<div className="popover-content" style={this.props.style}>
			{this.props.children}
		</div>`


