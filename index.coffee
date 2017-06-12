Quill = require("quill")

config = require("./config")
Toolbar = require("./modules/toolbar")

RESOURCES_TAGS = [
    "img",
    "video",
    "audio"
]

class Resources

    constructor: (quill, options)->
        @quill = quill
        @options = options

        @clickOnRoot = @clickOnRoot.bind(@)
        @clickOnFigure = @clickOnFigure.bind(@)
        @checkImage = @checkImage.bind(@)

        @quill.root.addEventListener("click", @clickOnRoot, true)

        # Content not already sets to editor container
        @quill.once "editor-change", =>
            for figure in Array::slice.call(@quill.root.querySelectorAll("figure"), 0)
                figure.addEventListener("click", @clickOnFigure, true)

        @quill.root.parentNode.style.position = @quill.root.parentNode.style.position || "relative"
        @modules = []

    onUpdate: ->
        @repositionElements()
        for m in @modules
            m.onUpdate()

    initializeModules: ->
        @removeModules();

        @modules = [
            new Toolbar(@)
        ]

        for m in @modules
            m.onCreate()

        @onUpdate()

    removeModules: ->
        for m in @modules
            m.onDestroy()

        @modules = [];

    clickOnRoot: (e)->
        if @resource
            @hide()
    clickOnFigure: (e)->
        e.stopPropagation()
        if RESOURCES_TAGS.indexOf(e.currentTarget.childNodes[0].tagName.toLowerCase()) != -1
            if @resource == e.currentTarget
                return

            if @resource
                @hide()

            @show(e.currentTarget)
        else if @resource
            @hide()

    show: (resource)->
        @resource = resource
        @showOverlay()
        @initializeModules()

    showOverlay: ->
        if @overlay
            @hideOverlay()

        @quill.setSelection(null)
        @setUserSelect("none")

        document.addEventListener("keyup", @checkImage, true)
        @quill.root.addEventListener("input", @checkImage, true)

        @overlay = document.createElement("div")
        @quill.root.parentNode.appendChild(@overlay)

        @repositionElements()

    hideOverlay: ->
        unless @overlay
            return

        @quill.root.parentNode.removeChild(@overlay)
        @overlay = null

        document.removeEventListener("keyup", @checkImage)
        @quill.root.removeEventListener("input", @checkImage)

        @setUserSelect("")

    repositionElements: ->
        if !@overlay || !@resource
            return

        parent = @quill.root.parentNode
        contentRect = @resource.childNodes[0].getBoundingClientRect()
        containerRect = parent.getBoundingClientRect()

        @overlay.style.position = "absolute"
        @overlay.style.left = "#{contentRect.left - containerRect.left - 1 + parent.scrollLeft}px"
        @overlay.style.top = "#{contentRect.top - containerRect.top + parent.scrollTop}px"
        @overlay.style.width = "#{contentRect.width}px"
        @overlay.style.height = "#{contentRect.height}px"

    hide: ->
        @hideOverlay()
        @removeModules()
        @resource = null

    setUserSelect: (value)->
        for prop in ["userSelect", "mozUserSelect", "webkitUserSelect", "msUserSelect"]
            @quill.root.style[prop] = value
            document.documentElement.style[prop] = value

    checkImage: (e)->
        if @resource
            if e.keyCode == 46 || e.keyCode == 8
                Quill.find(@resource).deleteAt(0)

            this.hide()

Quill.register('modules/resources', Resources)
