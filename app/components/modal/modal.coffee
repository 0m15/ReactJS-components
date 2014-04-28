`/** @jsx React.DOM */`

# TODO
# - Use an unique <OverlayComponent> for all overlayed components
React = require "react/addons"

Modal = React.createClass
  killClick: (e) ->
    e.stopPropagation()

  handleBackdropClick: (e) ->
    @props.onRequestClose(e);

  render: ->
    return @transferPropsTo `
    	<div>
        <div className="modal-backdrop" onClick={this.handleBackdropClick}></div>
        <ModalContent target={document.body} placement="down" anchor="center" onClick={this.killClick}>
          {this.props.children}
        </ModalContent>
      </div>`

ModalContent = React.createClass
  render: ->
    `<div className="modal-content">{this.props.children}</div>`

ModalLink = React.createClass
  mixins: [LayeredComponentMixin, ToggableStateMixin]

  handleClick: (e) ->
    @handleToggle(e)
  
  renderLayer: ->
    if not @state.open
      return `<span />`
    
    `<Modal onRequestClose={this.handleClick}>
      {this.props.children}
     </Modal>
    `
  render: ->
    if @props.title
      `<a href="javascript:;" role="button" onClick={this.handleClick}>Open modal</a>`
    else
      `<span/>`

module.exports = Modal