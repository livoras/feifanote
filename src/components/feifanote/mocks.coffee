makeNote = (name)->
  {
    name: name 
    activedPageIndex: Math.floor(Math.random * 30) 
    pages: (makePage() for i in [1..30])
  }

makePage = ->
  {content: "#{Math.random()}"}

names = ['Math', 'English', 'Database', 'Python', 'Jerry', 'JavaScript', 'NodeJS', 'PHP', 'Livoras']
notebooks = (makeNote(name) for name in names)

module.exports = {notebooks}
