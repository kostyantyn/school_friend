module SchoolFriend
  module REST
    class Auth
      include APIMethods

      api_method :login
      api_method :login_by_token
      api_method :expire_session, session_only: true
      api_method :touch_session,  session_only: true
    end
  end
end
