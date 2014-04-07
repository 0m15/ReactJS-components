# `/** @jsx React.DOM */`


classSet = React.addons.classSet

Tooltip = React.createClass
	mixins: [ToggableStateMixin, AbsolutePositionMixin]

	render: ->
		classes = classSet
			open: @state.open
			tooltip: true

		`<span className={classes}>
			<a href="" onMouseOver={this.handleToggle} onMouseOut={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<TooltipContent ref="menu" style={this.state.style}>{this.props.children}</TooltipContent>
		</span>
		`
TooltipContent = React.createClass
	render: ->
		`<div className="tooltip-content" style={this.props.style}>
			{this.props.children}
		</div>`


