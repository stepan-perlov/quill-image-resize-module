defaults =
    alignLeft: {
        innerHTML: "<i class=\"material-icons\">format_align_left</i>"
        className: "mdl-button mdl-js-button mdl-button--icon"
    }
    alignCenter: {
        innerHTML: "<i class=\"material-icons\">format_align_center</i>"
        className: "mdl-button mdl-js-button mdl-button--icon"
    }
    alignRight: {
        innerHTML: "<i class=\"material-icons\">format_align_right</i>"
        className: "mdl-button mdl-js-button mdl-button--icon"
    }

module.exports =
    config: defaults
    extend: (config)->
        for key, value of config
            defaults[key] = value
