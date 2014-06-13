feifanoteTpl = require './feifanote.html'
mocks = require './mocks.coffee'

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      activedNotebook: {}
      notebooks: mocks.notebooks
