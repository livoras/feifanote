notebooksBarTpl = require './notebooks-bar.html'
mocks = require './mocks.coffee'

Vue.component 'f-notebooks-bar',
  template: notebooksBarTpl

  data:
    notebooks: mocks.notebooks
    activedNotebook: null 

  methods:  
    activeNotebook: (notebook)->
      @activedNotebook = notebook
      @$dispatch 'notebooks-bar:actived', notebook
