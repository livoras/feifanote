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
      log.debug id
      if not id then return
      if id == @user.active_notebook_id then return
      save @
      to_activate_notebook = _.find @notebooks, {id}
      if not to_activate_notebook.loaded
        databus.loadPages to_activate_notebook, (pages)=>
          log.debug "Pages of #{id} loaded", pages
          to_activate_notebook.pages = pages
          active to_activate_notebook, @
      else active to_activate_notebook, @

    activatePage: (id)->
      if id == @activeNotebook.active_page_id then return
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

    createNewNotebook: ->
      notebook = 
        editMode: yes
        pages: null 
        id: null
        active_page_id: null
        name: null
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
          reActivateNotebooks @, toDeleteId
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

    enableEditMode: (vm, event)->
      vm.editMode = yes
      # Immediately focus will never work for it isn't shown by vue.
      # So, here is needed to be a setTimeout
      defer -> vm.$el.querySelector("input").focus()

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
    vm.user.active_notebook_id = toActivateNotebook.id
    databus.makeNotebookActive toActivateNotebook, ->
      log.debug "Notebook active after deletion."
      callback?()

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

active = (to_activate_notebook, vm)=>
  vm.user.active_notebook_id = to_activate_notebook.id
  databus.makeNotebookActive to_activate_notebook, =>
    log.debug "Notebook active"

defer = (fn)->
  setTimeout fn, 10