`/** @jsx React.DOM */`

React = require "react/addons"

PropTypes = React.PropTypes
classSet = React.addons.classSet


Button = React.createClass
	propTypes:
		title: PropTypes.renderable
		icon: PropTypes.renderable
		type: PropTypes.string
		loader: PropTypes.renderable

	getDefaultProps: ->
		type: 'button'
		icon: null

	getInitialState: ->
		active: false
		disabled: false
		loading: false

	setEnabled: (enabled) ->
		@setState
			enabled: enabled

	setActive: (active) ->
		@setState
			active: active

	setLoading: (loading) ->
		@setState
			loading: loading

	getDefaultProps: ->
		title: 'button'

	handleClick: (e) ->
		e.preventDefault()
		if @props.onClick?
			@props.onClick(e)

	render: ->
		classes = classSet
			active: @state.active
			loading: @state.loading
			disabled: !@state.enabled

		if @state.loading
			loader = @props.loader

		@transferPropsTo `<button className={classes} onClick={this.handleClick} className="btn" href="">
			{!this.state.loading ? this.props.title : loader}
		</button>`

module.exports = Button
