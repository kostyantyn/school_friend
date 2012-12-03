module SchoolFriend
  module REST
    class PhotosV2
      include APIMethods

      api_method :get_upload_url
      api_method :commit,         method: 'POST'
    end
  end
end