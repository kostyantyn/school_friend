module SchoolFriend
  module REST
    class Widget
      include APIMethods

      api_method :get_widgets
      api_method :get_widget_content
    end
  end
end