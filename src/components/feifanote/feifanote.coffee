feifanoteTpl = require './feifanote.html'
{ajax, eventbus, log} = wuyinote.common

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: {}

  methods:
    clickHandler: ->
      if @appStatus.dashboardActive
        @appStatus.dashboardActive = off

  created: ->
    @appStatus = wuyinote.common.appStatus
    listenShortCutToggleDashboard @
    watchAndSync @

listenShortCutToggleDashboard = (vm)->    
    document.addEventListener "keydown", (event)=>
      if event.ctrlKey and event.keyCode is 192
        vm.appStatus.dashboardActive = not vm.appStatus.dashboardActive

watchAndSync = (vm, callback)->
