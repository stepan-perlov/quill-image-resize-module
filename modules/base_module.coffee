class BaseModule
    constructor: (res)->
        @overlay = res.overlay
        @resource = res.resource
        @options = res.options
        @requestUpdate = res.onUpdate.bind(res)
    onCreate: ->
    onDestroy: ->
    onUpdate: ->

module.exports = BaseModule
