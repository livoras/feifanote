{eventbus, databus, log} = wuyinote.common

appStatus = wuyinote.common.appStatus = {}
user = initData.user
wuyinote.common.currentUser = user
appStatus.user = user

initApp = ->     
  if user.active_notebook_id is -1
    initForFirst => initActive()
  else  
    loadNotebooksStatus => initActive()

initForFirst = (callback)->
  currentUser = wuyinote.common.currentUser
  notebookData = {name: currentUser.username, index: 1}
  log.debug notebookData
  databus.createNewNotebook notebookData, (notebook)->
    log.debug 'new notebook created, ok'
    appStatus.notebooks = [notebook]
    databus.makeNotebookActive notebook, ->
      log.debug 'notebook activated, ok'
      appStatus.user.active_notebook_id = notebook.id
    databus.createNewPage notebook, (page)->  
      log.debug 'new page created, ok'
      if not page.content then page.content = "Welcome to WuYinote."
      notebook.pages = [page]
      databus.makePageActive notebook, page, ->
        log.debug 'page activated, ok'
        notebook.active_page_id = page.id
        callback?()

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
  log.debug appStatus.user.active_notebook_id
  mainVm.currentView = "f-feifanote"

mainVm = new Vue 
  el: '#container'
  data:
    currentView: ''
    appStatus: appStatus
  created: ->
    if not initData.is_login
      @currentView = 'f-entry'
    else initApp()
    eventbus.on "entry:login-success", (data)->
      user = wuyinote.common.currentUser = data
      appStatus.user = user
      initApp()
