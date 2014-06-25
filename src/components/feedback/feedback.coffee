feedbackTpl = require './feedback.html'
{ajax, eventbus, databus} = wuyinote.common

PLACEHOLDER_DEFAULT = "期待你的宝贵意见！"

Vue.component 'f-feedback',
  template: feedbackTpl
  data:
    placeholder: PLACEHOLDER_DEFAULT
  methods: 
    showFeedback: ->
      @isFeedbackShow = yes
      setTimeout =>
        @$text.focus()
      , 350  
    hideFeedback: ->
      @isFeedbackShow = no
      @placeholder = PLACEHOLDER_DEFAULT
      @content = ""
    send: ->
      @placeholder = "发送中..."
      if @content.length is 0
        @placeholder = "说点什么吧~"
        @$text.focus()
      else
        databus.sendFeedback {content: @content}, =>
          @placeholder = "收到~！"
          @content = ""
          setTimeout =>
            @hideFeedback()
          , 800
        , (msg)=>
          alert "收不到~！#{msg}"
  created: ->
    @$text = @$el.querySelector("textarea")
    eventbus.on "feedback:show-feedback", => @showFeedback()

