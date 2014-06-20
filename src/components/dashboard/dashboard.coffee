dashboardTpl = require './dashboard.html'
{databus, log} = wuyinote.common

Vue.component 'f-dashboard',
  template: dashboardTpl

  computed: 
    activeNotebook:
      $get: ->
        _.find @notebooks, {id: @user.active_notebook_id}

  methods:
    activateNotebook: (id)->
      @user.active_notebook_id = id
    activatePage: (id)->
      @activeNotebook.active_page_id = id
    clickHandler: (event)->
      event.stopPropagation()
    createNewPage: ->
      activeNotebook = @activeNotebook
      log.debug 'fuc,..'
      databus.createNewPage activeNotebook, (page)->
        log.debug "Page created, ok"
        activeNotebook.pages.push(page)
        databus.makePageActive activeNotebook, page, ->
          log.debug "Page actived, ok."
          activeNotebook.active_page_id = page.id
