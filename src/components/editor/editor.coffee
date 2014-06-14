editorTpl = require './editor.html'

Vue.component 'f-editor',
  template: editorTpl
  computed:
    content:
      $get: ->
        @activedNotebook.pages[@activedNotebook.activedPageIndex].content
        
      $set: (value)->
        @activedNotebook.pages[@activedNotebook.activedPageIndex].content = value
