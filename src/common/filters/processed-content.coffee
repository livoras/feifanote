Vue.filter 'processed-content', (value)->
  if value
    return value.replace /<[^>]*>/g, ""
