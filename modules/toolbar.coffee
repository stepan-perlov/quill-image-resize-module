Quill = require("quill")

BaseModule = require("./base_module");
config = require("../config.coffee").config

Parchment = Quill.imports.parchment
Align = new Parchment.Attributor.Class("align", "align")

alignStyles =
    alignLeft: {
        apply: (resource)->
            Align.add(resource, "left")
        isApplied: (resource)->
            Align.value(resource) == "left"
    }
    alignCenter: {
        apply: (resource)->
            Align.add(resource, "center")
        isApplied: (resource)->
            Align.value(resource) == "center"
    }
    alignRight: {
        apply: (resource)->
            Align.add(resource, "right")
        isApplied: (resource)->
            Align.value(resource) == "right"
    }


class Toolbar extends BaseModule
    onCreate: (res)->
        @el = document.createElement("div")
        @_addButtons()
        @overlay.appendChild(@el)
    _addButtons: ->
        result = document.createDocumentFragment()
        for key, style of alignStyles
            item = document.createElement("span")
            item.innerHTML = config[key].innerHTML
            item.className = config[key].className
            item.addEventListener "click", ((key, style)=>
                =>
                    if style.isApplied(@resource)
                        Align.remove(@resource)
                    else
                        style.apply(@resource)

                    @requestUpdate()
            )(key, style)
            result.appendChild(item)

        @el.appendChild(result)

module.exports = Toolbar
