editorTpl = require './editor.html'

Vue.component 'f-editor',
  template: editorTpl
  computed:
    content:
      $get: ->
        @activeNotebook.pages[@activeNotebook.activePageIndex].content
        
      $set: (value)->
        @activeNotebook.pages[@activeNotebook.activePageIndex].content = value
