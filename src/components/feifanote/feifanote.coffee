feifanoteTpl = require './feifanote.html'
mocks = require './mocks.coffee'

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    appStatus: 
      user: mocks.user
      activeNotebook: mocks.activeNotebook
      notebooks: mocks.notebooks
