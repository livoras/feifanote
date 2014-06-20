{log, databus} = wuyinote.common
editorTpl = require './editor.html'

autoSave = (vm)->    
  AUTO_SAVE_TIME = 5000
  setInterval ->
    if not vm.dirty then return
    activePage = vm.activePage
    databus.savePageContent activePage.id, activePage.content, ->
      log.debug "Auto saved, ok."
      vm.dirty = no
  , AUTO_SAVE_TIME  

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
  created: ->
    setTimeout => @dirty = no
    autoSave @

