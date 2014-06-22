{log, databus} = wuyinote.common
editorTpl = require './editor.html'

saveContent = (vm)->    
  activePage = vm.activePage
  if not vm.dirty then return
  databus.savePageContent activePage.id, activePage.content, ->
    log.debug "Content saved, ok."
    vm.dirty = no

Vue.component 'f-editor',
  template: editorTpl
  computed:
    activeNotebook: 
      $get: ->
        _.find @notebooks, {id: @user.active_notebook_id}
    activePage:
      $get: ->
        _.find @activeNotebook.pages, {id: @activeNotebook.active_page_id}
    content:
      $get: ->
        @activePage.content
      $set: (value)->
        @activePage.content = value
        @dirty = yes
  methods:
    checkToSave: (event)->
      S_KEY = 83
      clearTimeout @saveTimer
      if event.ctrlKey and event.keyCode is S_KEY
        saveContent @
        event.preventDefault()
        return
      @saveTimer = setTimeout =>
        saveContent @
      , 3 * 1000
  created: ->
    setTimeout => @dirty = no
