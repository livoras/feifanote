headerTpl = require './header.html'
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
    action = @$el.querySelector("#dashboard-action")
    new Opentip action, "快捷键：Ctrl + `", 
      delay: 0
      background: "#fff"
      borderColor: "#eee"
