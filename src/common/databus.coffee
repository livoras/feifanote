jqueryAjax = require '../../lib/ajax'

databus = module.exports = {}

databus.ajax = ajax = (options)->
  if options.data
    options.contentType = 'application/json'
    options.data = JSON.stringify options.data
  if options.error
    _error = options.error
    options.error = (e)->
      message = (JSON.parse e.responseText).message
      _error message, e.status
  return jqueryAjax options

databus.createNewNotebook = (data, callback)->
  ajax
    url: "/notebooks"
    type: "POST"
    data: data
    success: (notebook)->
      callback?notebook

databus.makeNotebookActive = (notebook, callback)->
  ajax
    url: "/notebooks/active_notebook"
    type: "PUT"
    data: {notebook_id: notebook.id}
    success: (data)->
      callback?data

databus.createNewPage = (notebook, callback)->
  data = 
    notebook_id: notebook.id
    index: 1
  ajax
    url: "/pages"
    type: "POST"
    data: data
    success: (data)->
      callback?data

databus.makePageActive = (notebook, page, callback)->  
  ajax
    url: "/pages/active_page"
    type: "PUT"
    data: {notebook_id: notebook.id, page_id: page.id}
    success: (data)->
      callback?data

databus.loadPages = (activeNotebook, callback)->
  if not activeNotebook.id then return
  if activeNotebook.loaded then return
  ajax
    url: "/notebooks/#{activeNotebook.id}"
    type: "GET"
    success: (notebook)->
      activeNotebook.loaded = true
      for page in notebook.pages
        page.content = "" if not page.content
      callback?notebook.pages
    error: (msg, status)->
      # TODO

databus.loadNotebooks = (callback)->
  ajax
    url: "/notebooks"
    type: "GET"
    success: (data)->
      callback?data.notebooks

databus.savePageContent = (pageId, pageContent, callback)->
  ajax
    url: "/pages/#{pageId}"
    type: "PATCH"
    data: {content: pageContent}
    success: (data)->
      callback?data
