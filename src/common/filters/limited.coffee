Vue.filter 'limited', (value)->
  if value
    value.slice 0, 20
