editorTpl = require './editor.html'

Vue.component 'f-editor',
  template: editorTpl
  computed:
    content:
      $get: ->
        if @activeNotebook and @activeNotebook.pages
          if @activeNotebook.active_page_index
            @activeNotebook.pages[@activeNotebook.active_page_index].content
        
      $set: (value)->
        if @activeNotebook and @activeNotebook.pages
          if @activeNotebook.active_page_index
            @activeNotebook.pages[@activeNotebook.active_page_index].content = value
