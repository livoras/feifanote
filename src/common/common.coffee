wuyinote = window.wuyinote = {}

util = require './util.coffee'
config = require './config.coffee'
EventEmitter = (require 'eventemitter2').EventEmitter2
_ = require 'lodash'
window._ = _
databus = require './databus.coffee'
require './filters/processed-content.coffee'
require './filters/limited.coffee'

eventbus = new EventEmitter maxLisnteners: Number.MAX_VALUE
log = debug: -> console.log.apply(console, arguments)
ajax = databus.ajax

wuyinote.common = module.exports = {
  util, ajax, log, databus
  eventbus, EventEmitter 
}
