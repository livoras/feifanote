headerTpl = require './header.html'

Vue.component 'f-header',
  template: headerTpl
  methods:
    toggleDashboard: (event)->
      @dashboardActive = not @dashboardActive
      event.stopPropagation()
