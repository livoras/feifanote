fainote = window.fainote = {}

util = require 'util'
ajax = require '../../lib/ajax'
require './filters/processed-content.coffee'

fainote.common = module.exports = {util, ajax}
