feifanoteTpl = require './feifanote.html'
mocks = require './mocks.coffee'

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      activedNotebook: mocks.activedNotebook
      notebooks: mocks.notebooks
