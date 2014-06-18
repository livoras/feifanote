dashboardTpl = require './dashboard.html'

Vue.component 'f-dashboard',
  template: dashboardTpl
  methods:
    activateNotebook: (notebook)->
      @activeNotebook = notebook.$data
    activatePage: (activePageIndex)->
      @activeNotebook.activePageIndex = activePageIndex
    clickHandler: (event)->
      event.stopPropagation()
