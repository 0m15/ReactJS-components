`/** @jsx React.DOM */`

# Component structure:
# - DropdownButton
#  - DropdownMenu
#   - DropdownMenuItem

# refs to some utils
classSet = React.addons.classSet

Tooltip = React.createClass
  render: ->
    return @transferPropsTo `
			<div className="tooltip-content" onClick={this.killClick}>
        {this.props.children}
    	</div>
      `

TooltipLink = React.createClass
  mixins: [LayeredComponentMixin, ToggableStateMixin]

  renderLayer: ->
  	if not @state.open
      return `<span />`
   	
    `<Tooltip>
    	<TooltipContent
    		target={this.getDOMNode()}
    		placement={this.props.placement} 
    		anchor={this.props.anchor}>
    		{this.props.title}
    	</TooltipContent>
    </Tooltip>
    `

  render: ->
    console.log 'render tooltip'
    style = 
      display: "inline-block"
    
    `<span style={style}>
      {this.props.item({ onMouseOver: this.handleToggle, onMouseOut: this.handleToggle})}
    </span>`

TooltipContent = React.createClass
	mixins: [AbsolutePositionMixin]

	render: ->
		`<div style={this.state.style}>{this.props.children}</div>`