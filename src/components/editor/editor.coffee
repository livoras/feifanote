{log, databus, eventbus} = wuyinote.common
editorTpl = require './editor.html'

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
        activePage = @activePage
        if activePage.content isnt value
          activePage.content = value
          @dirty = yes
  methods:
    deferToSave: ->
      clearTimeout @saveTimer
      @saveTimer = setTimeout =>
        saveContent @
      , 3 * 1000
  created: ->
    listenScrollToAjustEditorbar @
    setTimeout => 
      @dirty = no
      @editor = new wysihtml5.Editor "editor",
        toolbar: "editor-toolbar"
        parserRules: wysihtml5ParserRules
        stylesheets: ["/lib/rich-editor.css"]
      @editor.on "load", =>
        syncContent @
        listenKeyDownActions @
        watchActivePageChangeAndSycnEditor @
        eventbus.emit "editor-loaded"

listenScrollToAjustEditorbar = (vm)->
  window.addEventListener "scroll", ->
    vm.floatBar = (document.body.scrollTop isnt 0)

syncContent = (vm)->
  sync = ->
    vm.content = vm.editor.composer.element.innerHTML
    vm.deferToSave()
  vm.editor.composer.element.addEventListener 'keyup', sync
  vm.editor.on "aftercommand:composer", sync

listenKeyDownActions = (vm)->
  vm.editor.composer.element.addEventListener 'keydown', (event)=>
    S_KEY = 83
    if event.ctrlKey
      if event.keyCode is S_KEY
        event.preventDefault()
        saveContent vm
      else if event.keyCode is 192
        eventbus.emit "toggle-dashboard"

watchActivePageChangeAndSycnEditor = (vm)->
  pageChange = ->
    vm.editor.composer.element.innerHTML = vm.activePage.content
  vm.$watch "user.active_notebook_id", pageChange
  eventbus.on "active-page-change", pageChange

saveContent = (vm)->    
  activePage = vm.activePage
  if not vm.dirty then return
  databus.savePageContent activePage.id, activePage.content, ->
    log.debug "Content saved, ok."
    vm.dirty = no
