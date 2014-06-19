mainVm = new Vue 
  el: '#container'
  data:
    currentView: ''
  created: ->
    if not initData.is_login
      @currentView = 'f-entry'
    else  
      @currentView = 'f-feifanote'
