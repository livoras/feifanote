feifanoteTpl = require './feifanote.html'

Vue.component 'f-feifanote',
  template: feifanoteTpl

  data:
    activedNotebook: null

  created: ->
    @$on 'notebooks-bar:actived', (notebook)=>
      @activedNotebook = notebook
