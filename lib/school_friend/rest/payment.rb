module SchoolFriend
  module REST
    class Payment
      include APIMethods

      api_method :get_user_account_balance, session_only: true
    end
  end
end