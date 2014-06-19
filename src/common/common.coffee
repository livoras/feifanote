wuyinote = window.wuyinote = {}

util = require './util.coffee'
jqueryAjax = require '../../lib/ajax'
config = require './config.coffee'
EventEmitter = (require 'eventemitter2').EventEmitter2

require './filters/processed-content.coffee'

ajax = (options)->
  options.contentType = 'application/json'
  options.url = config.server + options.url
  if options.data
    options.data = JSON.stringify options.data
  if options.error
    _error = options.error
    options.error = (e)->
      message = (JSON.parse e.responseText).message
      _error message, e.status
  return jqueryAjax options

eventbus = new EventEmitter maxLisnteners: Number.MAX_VALUE

wuyinote.common = module.exports = {
  util, ajax, eventbus, EventEmitter
}
