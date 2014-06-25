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
    validAndNotify @

focusToggle = (vm)->
  vm.$watch "signupFormShow", (value)->
    setTimeout ->
      if value
        vm.$el.querySelector("div.signup-form input").focus()
      else  
        vm.$el.querySelector("div.login-form input").focus()

validAndNotify = (vm)->
  validEmail vm
  validUsername vm
  validPassword vm

validEmail = (vm)->  
  vm.$watch "signupData.email", (email)->
    if email.length > 0
      EMAIL_RE = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
      if not EMAIL_RE.test email
        vm.isEmailValid = no
        vm.emailNotification = "邮箱格式不正确"
      else
        vm.isEmailValid = yes
        vm.emailNotification = "邮箱格式正确"

validUsername = (vm)->
  vm.$watch "signupData.username", (username)->
    if username.length > 0
      USERNAME_RE = /^[\w\d_]{4,30}$/
      if not USERNAME_RE.test username
        vm.isUernameValid = no
        vm.usernameNotification = "4~30个英文字符、数字、下划线"
      else
        vm.isUernameValid = yes
        vm.usernameNotification = "用户名格式正确"

validPassword = (vm)->
  vm.$watch "signupData.password", (password)->
    if password.length > 0
      if 6 <= password.length <= 30
        vm.isPasswordValid = yes
        vm.passwordNotification = "密码格式正确"
      else
        vm.isPasswordValid = no
        vm.passwordNotification = "密码格式不正确"
