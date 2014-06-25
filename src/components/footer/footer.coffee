footerTpl = require './footer.html'
{eventbus} = wuyinote.common

Vue.component 'f-footer',
  template: footerTpl
  methods: 
    feedback: ->
      eventbus.emit "feedback:show-feedback"
