{eventbus, databus, log} = wuyinote.common

appStatus = wuyinote.common.appStatus = {}
user = initData.user
wuyinote.common.currentUser = user
appStatus.user = user

initApp = ->     
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
  mainVm.currentView = "f-feifanote"
  mainVm.maskShow = no

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
