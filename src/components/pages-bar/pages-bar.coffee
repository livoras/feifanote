pagesBarTpl = require './pages-bar.html'

Vue.component 'f-pages-bar',
  template: pagesBarTpl
  methods:
    activePage: (activedPageIndex)->
      @activedNotebook.activedPageIndex = activedPageIndex
