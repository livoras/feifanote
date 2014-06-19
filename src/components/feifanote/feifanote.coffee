feifanoteTpl = require './feifanote.html'
mocks = require './mocks.coffee'
{ajax, eventbus} = wuyinote.common

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      dashboardActive: false
      user: {}
      activeNotebook: mocks.activeNotebook
      notebooks: mocks.notebooks
  methods:
    clickHandler: ->
      if @appStatus.dashboardActive
        @appStatus.dashboardActive = off
  created: ->
    @appStatus.user = wuyinote.common.currentUser
    watchProperties @
    listenShortCutToggleDashboard @
    loadNotebooks @

watchProperties = (vm)->
  vm.$watch "appStatus.activeNotebook", (activeNotebook)->
    if not activeNotebook.pages
      activeNotebook.pages = []
      loadPages activeNotebook

loadPages = (activeNotebook)->      
  console.log activeNotebook
  ajax
    url: "/notebooks/#{activeNotebook.id}"
    type: "GET"
    success: (data)->
      pages = data.notebook.pages
      activeNotebook.pages = pages
    error: (msg, status)->
      # TODO


listenShortCutToggleDashboard = (vm)->    
    document.addEventListener "keydown", (event)=>
      if event.ctrlKey and event.keyCode is 192
        vm.appStatus.dashboardActive = not vm.appStatus.dashboardActive

loadNotebooks = (vm)->
  ajax
    url: "/notebooks"
    type: "GET"
    success: (data)->
      appStatus = vm.appStatus
      currentUser = appStatus.user
      appStatus.notebooks = data.notebooks
      appStatus.activeNotebook = data.notebooks[currentUser.active_notebook_id]
