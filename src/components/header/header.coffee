headerTpl = require './header.html'
logoTpl = require './logo-info.html'
{ajax} = wuyinote.common

Vue.component 'f-header',
  template: headerTpl
  methods:
    toggleDashboard: (event)->
      @dashboardActive = not @dashboardActive
      event.stopPropagation()
    logout: -> 
      ajax
        url: "/users/me"
        type: "DELETE"
        success: ->
          console.log "Logout success."
          window.location.reload()
  created: ->
    setDefaultStyle()
    dashboardActionShortcut @
    setTimeout => logoInfo @

dashboardActionShortcut = (vm)->
  action = vm.$el.querySelector("#dashboard-action")
  new Opentip action, "快捷键：Ctrl + `"

logoInfo = (vm)->
  logo = vm.$el.querySelector("div.logo")
  logoTpl = logoTpl.replace("notebooksLimitation", vm.user.notebooks_limitation)
  logoTpl = logoTpl.replace("pagesLimitation", vm.user.pages_limitation)
  new Opentip logo, logoTpl, {target: null}

setDefaultStyle = ->
  Opentip.styles.wuyinote = 
    target: true
    delay: 0
    tipJoint: "bottom"
    background: "#fff"
    borderColor: "#eee"

  Opentip.defaultStyle = "wuyinote"
