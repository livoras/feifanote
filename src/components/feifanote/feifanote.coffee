feifanoteTpl = require './feifanote.html'
mocks = require './mocks.coffee'

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      dashboardActive: false
      user: mocks.user
      activeNotebook: mocks.activeNotebook
      notebooks: mocks.notebooks
  methods:
    clickHandler: ->
      if @appStatus.dashboardActive
        @appStatus.dashboardActive = off
