makeNote = (name)->
  {
    name: name 
    activePageIndex: Math.floor(Math.random() * 30) 
    pages: (makePage() for i in [1..30])
  }

makePage = ->
  {content: "#{Math.random()}"}

names = ['Math', 'English', 'Database', 'Python', 'Jerry', 'JavaScript', 'NodeJS', 'PHP', 'Livoras']
notebooks = (makeNote(name) for name in names)
activeNotebook = notebooks[Math.floor(Math.random() * notebooks.length)]
user = {id: 1, username: "Livoras", email: "me@livoras.com"}

module.exports = {notebooks, activeNotebook, user}
