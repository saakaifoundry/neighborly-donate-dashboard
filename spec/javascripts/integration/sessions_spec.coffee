describe 'Integration: Sessions', ->
  before ->
    invalidateSession()

  after ->
    $.mockjaxClear()
    Dashboard.reset()

  it 'redirects to new session page', ->
    expect(1)
    visit '/'
    andThen ->
      equal(currentRouteName(), 'sessionsNew')

  it 'has page title in the header', ->
    expect(1)
    visit '/sessions/new'
    andThen ->
      equal find('.header').text(), 'Sign In'

  describe 'sign in', ->
    context 'When it succeeds', ->
      it 'redirects to index and shows the user name', ->
        expect(2)
        stubAjax 'POST', '/api/sessions', 201,
          {
            user_id: 1,
            access_token: 'some_token'
          }

        stubAjax 'GET', '/api/users/1', 200, FIXTURES.user(1)

        visit '/sessions/new'

        andThen ->
          fillIn('input[type=text]', 'foo@bar.com')
          fillIn('input[type=password]', 'foo@bar.com')
          click('input[type=submit]')

        andThen ->
          equal(currentRouteName(), 'index')
          equal find('.current-user-name').text(), 'Foo Bar'

    context 'When it fails', ->
      it 'shows the error message', ->
        invalidateSession()
        expect(2)
        stubAjax 'POST', '/api/sessions', 401, {}

        visit '/sessions/new'

        andThen ->
          fillIn('input[type=text]', 'foo@bar.com')
          fillIn('input[type=password]', 'foo@bar.com')
          click('input[type=submit]')

        andThen ->
          equal(currentRouteName(), 'sessionsNew')
          equal find('.notification').text(), 'Invalid email or password.'

  describe 'sign out', ->
    it 'has a sign out button', ->
      expect(1)
      authenticateSession()

      stubAjax 'DELETE', '/api/sessions', 200, {}

      visit '/'

      andThen ->
        equal find('header .user-sign-out').length,  1
