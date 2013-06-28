require 'forwardable'

module SchoolFriend
  REST_NAMESPACES = %w[auth callbacks discussions events friends messages notifications payment photos photos_v2 share stream stream users widget].freeze

  class << self
    extend Forwardable

    attr_accessor :application_id, :application_key, :secret_key, :api_server, :logger

    def_delegators :session, *REST_NAMESPACES

    def session(options = {})
      Session.new(options)
    end
  end

  self.logger = Logger.new(STDOUT)
  self.logger.level = Logger::WARN

end

require 'school_friend/version'
require 'school_friend/session'
require 'school_friend/api_methods'
require 'school_friend/rest/auth'
require 'school_friend/rest/callbacks'
require 'school_friend/rest/discussions'
require 'school_friend/rest/events'
require 'school_friend/rest/friends'
require 'school_friend/rest/messages'
require 'school_friend/rest/notifications'
require 'school_friend/rest/payment'
require 'school_friend/rest/photos'
require 'school_friend/rest/photos_v2'
require 'school_friend/rest/share'
require 'school_friend/rest/stream'
require 'school_friend/rest/users'
require 'school_friend/rest/widget'
