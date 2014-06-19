entryTpl = require './entry.html'
console.log entryTpl
Vue.component 'f-entry',
  template: entryTpl
  data:
    titleShow: no
  created: ->  
    setTimeout =>
      @titleShow = yes
    , 100
