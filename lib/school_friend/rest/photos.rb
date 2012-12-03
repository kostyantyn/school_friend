module SchoolFriend
  module REST
    class Photos
      include APIMethods

      api_method :create_album
      api_method :delete_album
      api_method :edit_album
      api_method :get_albums
      api_method :get_photo_info
      api_method :get_photo_marks,       session_only: true
      api_method :get_user_album_photos
      api_method :get_user_photos
      api_method :mark_user_photo,       session_only: true
      api_method :set_album_main_photo
    end
  end
end