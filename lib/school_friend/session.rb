require 'net/http'
require 'digest'

module SchoolFriend
  class Session
    class RequireSessionScopeError < ArgumentError
    end

    attr_reader :options, :session_scope

    def initialize(options = {})
      @options       = options
      @session_scope = options[:session_key] && options[:session_secret_key]
    end

    # Returns true if API call is performed in session scope
    #
    # @return [TrueClass, FalseClass]
    alias_method :session_scope?, :session_scope

    # Returns true if API call is performed in application scope
    #
    # @return [TrueClass, FalseClass]
    def application_scope?
      not session_scope?
    end

    # Returns application key
    #
    # @return [String]
    def application_key
      SchoolFriend.application_key
    end

    # Returns signature for signing request params
    #
    # @return [String]
    def signature
      @signature ||= session_scope? ? options[:session_secret_key] : SchoolFriend.secret_key
    end

    # Returns API server
    #
    # @@return [String]
    def api_server
      SchoolFriend.api_server
    end

    # Signs params
    #
    # @param [Hash] params
    # @return [Hash] returns modified params
    def sign(params = {})
      params = additional_params.merge(params)
      digest = params.sort_by(&:first).map{ |key, value| "#{key}=#{value}" }.join
      params[:sig] = Digest::MD5.hexdigest("#{digest}#{signature}")
      params
    end

    # Returns additional params which are required for all requests.
    # Depends on request scope.
    #
    # @return [Hash]
    def additional_params
      @additional_params ||= if session_scope?
        {application_key: application_key, session_key: options[:session_key]}
      else
        {application_key: application_key}
      end
    end

    # Performs API call to Odnoklassniki
    #
    # @example Performs API call in current scope
    #   school_friend = SchoolFriend::Session.new
    #   school_friend.api_call('widget.getWidgets', wids: 'mobile-header,mobile-footer') # Net::HTTPResponse
    #
    # @example Force performs API call in session scope
    #   school_friend = SchoolFriend::Session.new
    #   school_friend.api_call('widget.getWidgets', {wids: 'mobile-header,mobile-footer'}, true) # SchoolFriend::Session::RequireSessionScopeError
    #
    #
    # @param [String] method API method
    # @param [Hash] params params which should be sent to portal
    # @param [FalseClass, TrueClass] force_session_call says if this call should be performed in session scope
    # @return [Net::HTTPResponse]
    def api_call(method, params = {}, force_session_call = false)
      raise RequireSessionScopeError.new('This API call requires session scope') if force_session_call and application_scope?

      uri = build_uri(method, params)
      Net::HTTP.get_response(uri)
    end

    # Builds URI object
    #
    # @param [String] method request method
    # @param [Hash] params request params
    # @return [URI::HTTP]
    def build_uri(method, params = {})
      uri = URI(api_server)
      uri.path  = '/api/' + method.sub('.', '/')
      uri.query = URI.encode_www_form(sign(params))
      uri
    end

    SchoolFriend::REST_NAMESPACES.each do |namespace|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{namespace}
          SchoolFriend::REST::#{namespace.capitalize.gsub(/_([a-z])/) { $1.upcase }}.new(self)
        end
      EOS
    end
  end
end