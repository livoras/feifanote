notebooksBarTpl = require './notebooks-bar.html'

Vue.component 'f-notebooks-bar',
  template: notebooksBarTpl
  methods:  
    activeNotebook: (notebook)->
      @activedNotebook = notebook.$data
