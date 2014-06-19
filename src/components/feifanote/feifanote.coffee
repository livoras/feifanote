feifanoteTpl = require './feifanote.html'
{ajax, eventbus} = wuyinote.common

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      dashboardActive: false
      user: {}
      activeNotebook: null
      notebooks: null
  methods:
    clickHandler: ->
      if @appStatus.dashboardActive
        @appStatus.dashboardActive = off
  created: ->
    @appStatus.user = wuyinote.common.currentUser
    watchProperties @
    listenShortCutToggleDashboard @
    loadNotebooks @
    initActive @

initActive = (vm)->
  if vm.appStatus.user.active_notebook_id == -1
    createNewNotebook (notebook)->
      vm.appStatus.notebooks.append notebook
      vm.appStatus.activeNotebook = notebook

createNewNotebook = (callback)->


createNewPage = (notebook, callback)->


watchProperties = (vm)->
  vm.$watch "appStatus.activeNotebook", (activeNotebook)->
    if activeNotebook and not activeNotebook.pages
      activeNotebook.pages = []
      loadPages activeNotebook

loadPages = (activeNotebook)->      
  if not activeNotebook.id then return
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
      if currentUser.active_notebook_id
        appStatus.activeNotebook = data.notebooks[currentUser.active_notebook_id]
