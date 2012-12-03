module SchoolFriend
  module REST
    class Notifications
      include APIMethods

      api_method :send_simple
      api_method :send_mass
    end
  end
end