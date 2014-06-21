dashboardTpl = require './dashboard.html'
{databus, log} = wuyinote.common

Vue.component 'f-dashboard',
  template: dashboardTpl

  computed: 
    activeNotebook:
      $get: ->
        _.find @notebooks, {id: @user.active_notebook_id}
    activePage:
      $get: ->
        _.find @activeNotebook.pages, {id: @activeNotebook.active_page_id}
  methods:
    activateNotebook: (id)->
      @user.active_notebook_id = id
    activatePage: (id)->
      @activeNotebook.active_page_id = id
      databus.makePageActive @activeNotebook, @activePage, ->
        log.debug "Page activated. ok"
    deletePage: (event, id)->
      log.debug "Deleting Page #{id}"
      event.stopPropagation()
    clickHandler: (event)->
      event.stopPropagation()
    createNewPage: ->
      activeNotebook = @activeNotebook
      databus.createNewPage activeNotebook, (page)->
        log.debug "Page created, ok"
        activeNotebook.pages.push(page)
        databus.makePageActive activeNotebook, page, ->
          log.debug "Page activated, ok."
          activeNotebook.active_page_id = page.id
