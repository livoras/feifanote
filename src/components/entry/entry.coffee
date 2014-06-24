entryTpl = require './entry.html'
{ajax, eventbus} = wuyinote.common

login = (user, vm)=>
  userData = {email, password} = user
  ajax
    url: "/users/me"
    type: "POST"
    data: userData
    success: (data)->
      wuyinote.common.currentUser = data
      eventbus.emit "entry:login-success", data
    error: (msg, status)->
      alert "#{msg}: #{status}"

Vue.component 'f-entry',
  template: entryTpl
  data:
    titleShow: no
    signupFormShow: yes
  methods:
    signup: ->
      ajax 
        url: "/users"
        type: "POST"
        data: @signupData
        success: (data)=>
          login @signupData, @
        error: (msg, status)->  
          alert status + ': ' + msg
    login: login
    enterToLogin: (event)->
      ENTER_KEY = 13
      if event.keyCode is ENTER_KEY then @login @loginData, @
    enterToSignup: (event)->  
      ENTER_KEY = 13
      if event.keyCode is ENTER_KEY then @signup()
  created: ->  
    setTimeout =>
      @titleShow = yes
    , 200
    focusToggle @

focusToggle = (vm)->
  vm.$watch "signupFormShow", (value)->
    setTimeout ->
      if value
        vm.$el.querySelector("div.signup-form input").focus()
      else  
        vm.$el.querySelector("div.login-form input").focus()
