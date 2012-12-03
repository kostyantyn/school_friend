module SchoolFriend
  module REST
    class Discussions
      include APIMethods

      api_method :get_discussions,               session_only: true
      api_method :get_discussion_comments_count, session_only: true
      api_method :add_discussion_comment,        session_only: true
      api_method :delete_discussion_comment,     session_only: true
      api_method :get_discussion_comments,       session_only: true
      api_method :mark_discussion_as_read,       session_only: true
    end
  end
end