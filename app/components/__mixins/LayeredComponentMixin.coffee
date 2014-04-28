React = require "react/addons"

# borrowed from @petehunt `ReactLayeredComponentMixin`
module.exports =
    componentWillUnmount: ->
        @_unrenderLayer()
        document.body.removeChild(@_target)
    
    componentDidUpdate: ->
        @_renderLayer()
    
    componentDidMount: ->
        @_target = document.createElement('div')
        document.body.appendChild(@_target)
        @_renderLayer()
    
    _renderLayer: -> 
        React.renderComponent(@renderLayer(), @_target)

    _unrenderLayer: ->
        React.unmountComponentAtNode(@_target)

    _getLayerNode: ->
        @_target.getDOMNode()