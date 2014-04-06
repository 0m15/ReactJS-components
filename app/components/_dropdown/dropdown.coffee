`/** @jsx React.DOM */`

# Component structure:
# - DropdownButton
#  - DropdownMenu
#   - DropdownMenuItem

# refs to some utils
classSet = React.addons.classSet

DropdownButton = React.createClass
	mixins: [AbsolutePositionMixin, ToggableStateMixin]

	render: ->	
		classes = classSet
			open: @state.open
			dropdown: true
			up: @props.direction == 'up'
			down: @props.direction == 'down'

		`<div className={classes}>
			<a href="" onClick={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<DropdownMenu ref="menu" items={this.props.items} onSelect={this.props.onSelect} style={this.state.style} />
		</div>
		`

DropdownMenu = React.createClass
	render: ->
		`<ul className="dropdown-menu" style={this.props.style}>
			{this.props.items.map(function(item, i) {
				return (<DropdownMenuItem item={item} onSelect={this.props.onSelect} key={i} />)
			}, this)}
		</ul>
		`

DropdownMenuItem = React.createClass
	render: ->
		`<li>
		 	<a href="" onClick={this.handleClick}>{this.props.item.title}</a>
		 </li>`

	handleClick: (e) ->
		e.preventDefault()
		@props.onSelect(@props.item)