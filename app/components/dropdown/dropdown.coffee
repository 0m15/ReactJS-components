`/** @jsx React.DOM */`

React = require 'react/addons'
CSSCore = require 'react/lib/CSSCore'
ReactTransitionEvents = require 'react/lib/ReactTransitionEvents'

ToggableStateMixin = require '../__mixins/ToggableStateMixin'
LayeredComponentMixin = require '../__mixins/LayeredComponentMixin'
AbsolutePositionMixin = require '../__mixins/AbsolutePositionMixin'
Button = require '../button/button'

# refs to some utils
classSet = React.addons.classSet
ReactTransitionGroup = React.addons.TransitionGroup

Dropdown = React.createClass

  handleBackdropClick: (e) ->
    @props.onRequestClose(e)

  render: ->
    return @transferPropsTo `
    	<div>
    		<div className="dropdown-backdrop" onClick={this.handleBackdropClick}></div>
        {this.props.children}
      </div>`

DropdownButton = React.createClass
  mixins: [LayeredComponentMixin, ToggableStateMixin]

  renderLayer: ->

  	if not @state.open
      return `<span />`

    `<Dropdown onRequestClose={this.handleToggle}>
    	<DropdownMenu
        position={this.props.position}
        target={this.getDOMNode()} 
        placement={this.props.placement}
        anchor={this.props.anchor} 
        onSelect={this.onSelect} 
        style={this.state.style}>
    		{this.props.children}
    	</DropdownMenu>
    </Dropdown>
    `

  render: ->
    `<Button title={this.props.title} onClick={this.handleToggle} />`

  onSelect: (item) ->
  	@props.onSelect(item)
  	@setState
  		open: false


DropdownMenu = React.createClass
  mixins: [AbsolutePositionMixin]

  getDefaultProps: ->
    transitionName: 'slide'

  transition: (name) ->
    console.log 'transition', name

    element = if name is 'enter' then @getDOMNode() else @_leavingEl
    className = @props.transitionName + '-' + name
    CSSCore.addClass(element, className)

    onTransitionEnd = ->
      console.log 'onTransitionEnd'
      ReactTransitionEvents.removeEndEventListener(element, onTransitionEnd)

    ReactTransitionEvents.addEndEventListener(element, onTransitionEnd)

  componentDidUpdate: (nextProps, nextState) ->
    console.log 'componentWillUpdate', nextState

  componentWillUnmount: ->
    console.log 'componentWillUnmount'
    @_leavingEl = document.createElement 'div'
    document.body.appendChild @_leavingEl
    @_leavingEl.innerHTML = @getDOMNode().innerHTML
    @transition('leave')

  componentDidMount: ->
    console.log 'didMount'
    @transition('enter')

  render: ->
    classes = classSet
      'dropdown-menu': true
      'slide': true

    `<ul className={classes} style={this.state.style}>
      {this.props.children}
    </ul>
    `

DropdownMenuItem = React.createClass
	render: ->
		`<a href="" onClick={this.handleClick}>{this.props.item.title}</a>`

	handleClick: (e) ->
		e.preventDefault()
		@props.onSelect(@props.item)

module.exports = DropdownButton