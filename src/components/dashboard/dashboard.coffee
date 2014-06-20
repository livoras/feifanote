dashboardTpl = require './dashboard.html'

Vue.component 'f-dashboard',
  template: dashboardTpl
  methods:
    activateNotebook: (id)->
      @user.active_notebook_id = id
    activatePage: (id)->
      @activeNotebook.active_page_id = id
    clickHandler: (event)->
      event.stopPropagation()
  computed: 
    activeNotebook:
      $get: ->
        _.find @notebooks, {id: @user.active_notebook_id}
