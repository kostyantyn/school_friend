module SchoolFriend
  module REST
    class Messages
      include APIMethods

      api_method :get_conversations, session_only: true
      api_method :get_list,          session_only: true
      api_method :get,               session_only: true
      api_method :send
      api_method :mark_as_read,      session_only: true
      api_method :mark_as_spam,      session_only: true
      api_method :delete,            session_only: true
    end
  end
end