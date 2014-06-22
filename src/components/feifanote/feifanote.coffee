feifanoteTpl = require './feifanote.html'
{ajax, eventbus, log} = wuyinote.common

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: {}

  methods:
    clickHandler: ->
      # if @appStatus.dashboardActive
      #   @appStatus.dashboardActive = off

  created: ->
    @appStatus = wuyinote.common.appStatus
    eventbus.on "toggle-dashboard", =>
      @appStatus.dashboardActive = not @appStatus.dashboardActive
    listenShortCutToggleDashboard @


listenShortCutToggleDashboard = (vm)->    
  document.addEventListener "keydown", (event)=>
    if event.ctrlKey and event.keyCode is 192
      eventbus.emit "toggle-dashboard"
