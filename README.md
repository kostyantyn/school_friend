# SchoolFriend

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'school_friend'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install school_friend

## Usage

    # Init the SchoolFriend Module
    SchoolFriend.application_id = ''
    SchoolFriend.application_key = ''
    SchoolFriend.secret_key = ''
    SchoolFriend.api_server = 'http://api.odnoklassniki.ru'

    # Example call to a method that doesn't require a session or oauth2 access token  
    puts SchoolFriend.users.is_app_user(:uid => "425634635") # Note that method name is underscored

    # Init an Oauth2 Session
    # You can init an oauth session in two ways:
    # 1. By providing the oauth code and let this gem to acquire the access token for you
    session = SchoolFriend.session(:oauth_code => code)

    # 2. By providing an access token and a refresh token you already have
    session = SchoolFriend.session(:access_token => access_token, :refresh_token => refresh_token)

    # Alternative - non oauth: Acquire a session with user's user_name and password (not recommanded)
    # Odnoklassniki's sandbox has no oauth2 support so you have to use this method there
    session = SchoolFriend.session(SchoolFriend.auth.login(:user_name => username, :password => password))

    # Once you have a session you can perform actions with it:
    puts session.users.get_current_user

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
