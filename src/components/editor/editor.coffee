editorTpl = require './editor.html'

Vue.component 'f-editor',
  template: editorTpl
  computed:
    content:
      $get: ->
        if @activeNotebook.pages
          @activeNotebook.pages[@activeNotebook.activePageIndex].content
        
      $set: (value)->
        if @activeNotebook.pages
          @activeNotebook.pages[@activeNotebook.activePageIndex].content = value
