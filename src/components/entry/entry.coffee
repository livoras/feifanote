entryTpl = require './entry.html'
promptTpl = require './prompt.html'
{ajax, eventbus, databus} = wuyinote.common

login = (user, vm)=>
  userData = {email, password} = user
  ajax
    url: "/users/me"
    type: "POST"
    data: userData
    success: (data)->
      vm.loginAlarmShow = no
      wuyinote.common.currentUser = data
      eventbus.emit "entry:login-success", data
    error: (msg, status)->
      vm.loginAlarmShow = yes
      vm.$el.querySelector("div.login-form input").focus()

signup = (vm)->
  ajax 
    url: "/users"
    type: "POST"
    data: vm.signupData
    success: (data)=>
      wuyinote.common.isFirstLogin = yes
      wuyinote.common.firstLoginTpl = promptTpl
      login vm.signupData, vm
    error: (msg, status)->  
      alert status + ': ' + msg

Vue.component 'f-entry',
  template: entryTpl
  data:
    titleShow: no
    signupFormShow: yes
  methods:
    login: login
    signup: ->
      if @isEmailValid and @isUsernameValid and @isPasswordValid
        signup @
        return
      alarmers = []
      if not @isEmailValid
        alarmers.push "邮箱"
      if not @isUsernameValid
        alarmers.push "用户名"
      if not @isPasswordValid
        alarmers.push "密码"
      @signupFormAlarm = alarmers.join("、") + "好像有点不大正确？"
    enterToLogin: (event)->
      ENTER_KEY = 13
      if event.keyCode is ENTER_KEY then @login @loginData, @
    enterToSignup: (event)->  
      ENTER_KEY = 13
      if event.keyCode is ENTER_KEY then @signup()
    checkEmailAvailability: ->
      if @isEmailValid
        @emailStatus = "loading"
        databus.checkEmailAvailability @signupData.email, =>
          @emailStatus = "ok"
          @emailNotification = "邮箱可用 :)"
        , =>
          @emailStatus = "used"
          @isEmailValid = no
          @emailNotification = "邮箱已注册 :("
        , =>
    checkUsernameAvailability: ->
      if @isUsernameValid
        @usernameStatus = "loading"
        databus.checkUsernameAvailability @signupData.username, =>
          @usernameStatus = "ok"
          @usernameNotification = "用户名可用 :)"
        , =>
          @usernameStatus = "used"
          @isUsernameValid = no
          @usernameNotification = "用户名已注册 :("
        , =>
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
      vm.emailStatus = undefined
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
      vm.usernameStatus = undefined
      USERNAME_RE = /^[\w\d_]{4,30}$/
      if not USERNAME_RE.test username
        vm.isUsernameValid = no
        vm.usernameNotification = "4~30个英文字符、数字、下划线"
      else
        vm.isUsernameValid = yes
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
