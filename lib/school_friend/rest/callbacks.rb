module SchoolFriend
  module REST
    class Callbacks

      attr_reader :session

      def initialize(session)
        @session = session
      end

      def payment(params = {})
      end
    end
  end
end