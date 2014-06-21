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
      if not id then return
      if id == @user.active_notebook_id then return
      save @
      @user.active_notebook_id = id
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
      notebook = {editMode: yes}
      @notebooks.push notebook
      setTimeout =>
        @$el.querySelector("input.last").focus()
      , 10
    deleteNotebook: (vm)->  
      if not vm.id then @notebooks.pop()
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
    enableEditMode: (vm, event)->
      vm.editMode = yes
      # Immediately focus will never work for it isn't shown by vue.
      # So, here is needed to be a setTimeout
      setTimeout -> 
        vm.$el.querySelector("input").focus()
      , 2
    checkAndSend: (vm, event)->
      input = vm.$el.querySelector("input")
      if vm.name.length is 0
        alert "笔记名字不能为空"
        input.focus()
        return yes
      if vm.name.length > 30
        alert "笔记名字不能超过16个字符"
        input.focus()
        return yes
      if vm.id
        modifyNotebookName vm, input
      else
        index = @notebooks.length + 1
        name = vm.name
        createNewNotebook {name, index}, vm, input, @

createNewNotebook = (data, notebookVM, input, dashboardVM)->
  databus.createNewNotebook data, (notebook)->
    _.extend notebookVM, notebook
    notebookVM.editMode = no
    log.debug "Notebook created, ok"
    ## HERE TO CREATE PAGE AND ACTIVE NOTEBOOK AND PAGE.
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
