dashboardTpl = require './dashboard.html'
{databus, log} = wuyinote.common

Vue.component 'f-dashboard',
  template: dashboardTpl

  computed: 
    activeNotebook:
      $get: ->
        _.find @notebooks, {id: @user.active_notebook_id}
    activePage:
      $get: ->
        _.find @activeNotebook.pages, {id: @activeNotebook.active_page_id}
  methods:
    activateNotebook: (id)->
      save @
      @user.active_notebook_id = id
    activatePage: (id)->
      save @
      @activeNotebook.active_page_id = id
      databus.makePageActive @activeNotebook, @activePage, ->
        log.debug "Page activated. ok"
    clickHandler: (event)->
      event.stopPropagation()
    createNewPage: ->
      activeNotebook = @activeNotebook
      databus.createNewPage activeNotebook, (page)->
        log.debug "Page created, ok"
        activeNotebook.pages.push(page)
        activeNotebook.active_page_id = page.id
        databus.makePageActive activeNotebook, page, ->
          log.debug "Page activated, ok."
    deletePage: (event, toDeleteId)->
      log.debug "Deleting Page #{toDeleteId}"
      event.stopPropagation()
      activeNotebook = @activeNotebook
      activePage = @activePage
      if activeNotebook.pages.length is 1
        alert "每本笔记本至少要有一页笔记哦"
        return
      databus.deletePage toDeleteId, ->
        reActivatePage activeNotebook, activePage, toDeleteId
        reOrderPages activeNotebook, toDeleteId

reOrderPages = (activeNotebook, toDeleteId)->
  toDeletePage = _.find activeNotebook.pages, {id: toDeleteId}
  realIndex = toDeletePage.index - 1
  activeNotebook.pages.splice(realIndex, 1)
  for page in activeNotebook.pages.slice realIndex
    page.index--

reActivatePage = (activeNotebook, activePage, toDeleteId, callback)->  
  if activePage.id is toDeleteId
    realIndex = activePage.index - 1
    pages = activeNotebook.pages
    toActivatePage = pages[realIndex + 1] or pages[realIndex - 1]
    activeNotebook.active_page_id = toActivatePage.id
    databus.makePageActive activeNotebook, toActivatePage, (page)->
      log.debug "Page active after deletion."
      callback?()

save = (vm)->
  activePage = vm.activePage
  databus.savePageContent activePage.id, activePage.content, ->
    log.debug "Save content before switching"
