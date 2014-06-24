{eventbus, databus, log} = wuyinote.common

appStatus = wuyinote.common.appStatus = {}
user = initData.user
wuyinote.common.currentUser = user
appStatus.user = user

initApp = ->     
  eventbus.on "editor-loaded", -> 
    log.debug "Editor Loaded! Hide mask."
    mainVm.maskShow = no
  loadNotebooksStatus => initActive()

loadNotebooksStatus = (callback)->
  databus.loadNotebooks (notebooks)->
    appStatus.notebooks = notebooks
    activeNotebook = _.find notebooks, {id: appStatus.user.active_notebook_id}
    databus.loadPages activeNotebook, (pages)-> 
      activeNotebook.pages = pages
      callback?()

initActive = ->  
  appStatus = appStatus
  log.debug appStatus.notebooks
  log.debug "App initialized!"
  document.body.className = ""
  mainVm.currentView = "f-feifanote"

mainVm = new Vue 
  el: '#container'
  data:
    maskShow: no
    currentView: ''
    appStatus: appStatus
  created: ->
    if not initData.is_login
      @currentView = 'f-entry'
    else 
      @maskShow = yes
      initApp()
    eventbus.on "entry:login-success", (data)=>
      @maskShow = yes
      user = wuyinote.common.currentUser = data
      appStatus.user = user
      initApp()
