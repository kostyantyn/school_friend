module SchoolFriend
  module REST
    class Friends
      include APIMethods

      api_method :get
      api_method :get_mutual_friends
      api_method :get_online
      api_method :get_app_users,     session_only: true
      api_method :get_birthdays
      api_method :are_friends,       session_only: true
    end
  end
end