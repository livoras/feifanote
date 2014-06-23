dashboardTpl = require './dashboard.html'
{databus, log, eventbus} = wuyinote.common

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
    scroll: (event)->
      event.preventDefault()
      vm = event.targetVM
      el = event.currentTarget
      DELTA = 40
      delta = if event.detail then event.detail * (-120) else event.wheelDelta
      if delta < 0
        el.scrollLeft += DELTA
      else 
        el.scrollLeft -= DELTA
    activateNotebook: (id)->
      if not id then return
      if id == @user.active_notebook_id then return
      save @
      toActivateNotebook = _.find @notebooks, {id}
      activeIfPageLoadedElseLoad toActivateNotebook, @

    activatePage: (id)->
      if id == @activeNotebook.active_page_id then return
      save @
      @activeNotebook.active_page_id = id
      eventbus.emit "active-page-change"
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
        eventbus.emit "active-page-change"
        databus.makePageActive activeNotebook, page, ->
          log.debug "Page activated, ok."

    createNewNotebook: ->
      notebook = 
        editMode: yes
        pages: null 
        id: null
        active_page_id: null
        name: ""
        index: @notebooks.length + 1
      @notebooks.push notebook
      defer => @$el.querySelector("input.last").focus()

    deleteNotebook: (event, toDeleteId)->  
      event.stopPropagation()
      activeNotebook = @activeNotebook
      if @notebooks.length is 1
        alert "至少要留有一本笔记本哦"
        return
      if confirm "该笔记本下所有笔记也会同时被删除，确认要删除吗？"
        log.debug "Deleting Notebook #{toDeleteId}"
        databus.deleteNotebook toDeleteId, =>
          reActivateNotebooks @, toDeleteId, =>
            reOrderNotebooks @, toDeleteId

    deletePage: (event, toDeleteId)->
      event.stopPropagation()
      activeNotebook = @activeNotebook
      activePage = @activePage
      if activeNotebook.pages.length is 1
        alert "每本笔记本至少要有一页笔记哦"
        return
      log.debug "Deleting Page #{toDeleteId}"
      databus.deletePage toDeleteId, ->
        reActivatePage activeNotebook, activePage, toDeleteId
        reOrderPages activeNotebook, toDeleteId

    enterHandlerOfNameInput: (vm, event)->
      ENTER_KEY = 13
      if event.keyCode is ENTER_KEY then @checkAndSend vm, event

    enableEditMode: (vm, event)->
      vm.editMode = yes
      # Immediately focus will never work for it isn't shown by vue.
      # So, here is needed to be a setTimeout
      defer -> 
        input = vm.$el.querySelector("input")
        input.focus()
        input.select()

    checkAndSend: (vm, event)->
      input = vm.$el.querySelector("input")
      result = isNameValid(vm.name)
      if not result.valid
        alert result.msg
        input.focus()
        return 
      if vm.id
        modifyNotebookName vm, input
      else
        index = @notebooks.length
        name = vm.name
        createNewNotebook {name, index}, vm, input, @

isNameValid = (name)->
  LEN = 30
  if not name or name.length is 0
    return {valid: no, msg: "笔记名字不能为空"}
  if name.length > LEN
    return {valid: no, msg: "笔记名字长度不能超过#{LEN}个字符"}
  {valid: yes}

createNewNotebook = (data, notebookVM, input, dashboardVM)->
  databus.createNewNotebook data, (notebook)->
    _.extend notebookVM, notebook
    log.debug "Notebook created, ok", notebook
    notebookVM.editMode = no
    active notebookVM, dashboardVM
  , (msg)->
    alert msg
    input.focus()

modifyNotebookName = (vm, input)->
  databus.modifyNotebookName vm, ->
    vm.editMode = no
    log.debug "Notebook name saved."
  , (msg, status)->
    alert msg
    input.focus()

reActivatePage = (activeNotebook, activePage, toDeleteId, callback)->  
  if activePage.id is toDeleteId
    realIndex = activePage.index - 1
    pages = activeNotebook.pages
    toActivatePage = pages[realIndex + 1] or pages[realIndex - 1]
    activeNotebook.active_page_id = toActivatePage.id
    eventbus.emit "active-page-change"
    databus.makePageActive activeNotebook, toActivatePage, (page)->
      log.debug "Page active after deletion."
      callback?()

reOrderPages = (activeNotebook, toDeleteId)->
  toDeletePage = _.find activeNotebook.pages, {id: toDeleteId}
  realIndex = toDeletePage.index - 1
  activeNotebook.pages.splice(realIndex, 1)
  for page in activeNotebook.pages.slice realIndex
    page.index--

reActivateNotebooks = (vm, toDeleteId, callback)->  
  if vm.activeNotebook.id is toDeleteId
    realIndex = vm.activeNotebook.index - 1
    notebooks = vm.notebooks
    toActivateNotebook = notebooks[realIndex + 1] or notebooks[realIndex - 1]
    activeIfPageLoadedElseLoad toActivateNotebook, vm, callback
  else callback?()

reOrderNotebooks = (vm, toDeleteId)->
  toDeleteNotebook = _.find vm.notebooks, {id: toDeleteId}
  realIndex = toDeleteNotebook.index - 1
  vm.notebooks.splice(realIndex, 1)
  for notebook in vm.notebooks.slice realIndex
    notebook.index--

save = (vm)->
  activePage = vm.activePage
  databus.savePageContent activePage.id, activePage.content, ->
    log.debug "Save content before switching"

activeIfPageLoadedElseLoad = (toActivateNotebook, vm, callback)->
  if not toActivateNotebook.loaded
    databus.loadPages toActivateNotebook, (pages)=>
      log.debug "Pages of #{toActivateNotebook.id} loaded", pages
      toActivateNotebook.pages = pages
      active toActivateNotebook, vm
      callback?()
  else 
    active toActivateNotebook, vm
    callback?()

active = (toActivateNotebook, vm)=>
  vm.user.active_notebook_id = toActivateNotebook.id
  databus.makeNotebookActive toActivateNotebook, =>
    log.debug "Notebook active"

defer = (fn)->
  setTimeout fn, 10