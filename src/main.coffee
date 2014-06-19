{eventbus} = wuyinote.common

mainVm = new Vue 
  el: '#container'
  data:
    currentView: ''
  created: ->
    if not initData.is_login
      @currentView = 'f-entry'
    else  
      wuyinote.common.currentUser = initData.user
      @currentView = 'f-feifanote'
    eventbus.on "entry:login-success", (data)=>
      @currentView = "f-feifanote"
