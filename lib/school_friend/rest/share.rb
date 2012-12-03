module SchoolFriend
  module REST
    class Share
      include APIMethods

      api_method :add_link, session_only: true
    end
  end
end