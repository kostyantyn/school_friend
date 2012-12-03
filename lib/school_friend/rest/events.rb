module SchoolFriend
  module REST
    class Events
      include APIMethods

      api_method :get,           session_only: true
      api_method :get_type_info
    end
  end
end