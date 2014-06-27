Dashboard.PageTitle = Ember.View.extend
  tagName: 'h1'
  content: []
  template: Ember.Handlebars.compile('{{view.content}}')

  router: Ember.computed 'controller', ->
    @get('controller').container.lookup 'router:main'

  currentPathObserver: (->
    @get 'router'
    @send 'updateTitleByRoute'
  ).observes('router.url').on('init')

  actions:
    updateTitleByRoute: ->
      content = []
      routes = @get('container').lookup('router:main')

      appTitle = @appTitle(routes)
      content.pushObject(appTitle) if appTitle

      currentRoute = routes.get('router.currentHandlerInfos').pop()

      if currentRoute.handler.title
        content.pushObject(currentRoute.handler.title)

      content.reverse()
      @setDocumentTittle(content.join(' - '))
      content.pop() # Remove the app title

      @set('content', content.join(' - '))
      @rerender()

  setDocumentTittle: (content)->
    $('title').html(content)

  appTitle: (routes)->
    title = false
    routes.get('router.currentHandlerInfos').forEach (route) ->
      if route.handler.routeName == 'application' && route.handler.title
        title = route.handler.title

    return title

Ember.Handlebars.helper 'page-title', Dashboard.PageTitle
