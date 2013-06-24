#!/usr/bin/env ruby

require 'logger'
require 'yaml'
require 'school_friend'
require 'time'
require 'socket'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

example_settings = YAML.load_file(File.dirname(__FILE__) + '/examples_settings.yaml')

puts "Login using Odnoklassniki: \"#{example_settings['oauth_server']}/oauth/authorize?client_id=#{example_settings['application_id']}&scope=#{example_settings['permission']}&response_type=code&redirect_uri=http://127.0.0.1:#{example_settings['listener_port']}\""

log.debug "Initiating server to catch the oauth code"
server = TCPServer.new(example_settings['listener_port'])
loop {
    log.debug "Server initiated"

    client = server.accept
    headers = "HTTP/1.1 200 OK\r\nDate: #{Time.now.httpdate}\r\nServer: Ruby\r\nContent-Type: text/html; charset=iso-8859-1\r\n\r\n"
    
    lines = "" 
    while line = client.gets and line !~ /^\s*$/
        lines << line.chomp
    end

    if match = /code=(\S*)/.match(lines)
        code = match[1]
        log.debug "Oauth code received: #{code}"

        # Init SchoolFriend module class vars
        SchoolFriend.application_id = example_settings['application_id']
        SchoolFriend.application_key = example_settings['application_key']
        SchoolFriend.secret_key = example_settings['secret_key']
        SchoolFriend.api_server = example_settings['api_server']
        log.debug "SchoolFriend module class variables initiated: #{SchoolFriend.application_id} #{SchoolFriend.application_key} #{SchoolFriend.secret_key} #{SchoolFriend.api_server} "

        # Set SchoolFriend's logger
        SchoolFriend.logger = log

        begin
            # Example for oauth_code based init
            session = SchoolFriend.session(:oauth_code => code)

            puts session.users.is_app_user
            puts session.users.get_current_user
            puts session.users.get_info

            # Example for access_token based init
            session = SchoolFriend.session(:access_token => session.options[:access_token], :refresh_token => session.options[:refresh_token])
            puts session.users.is_app_user
            puts session.users.get_current_user
            puts session.users.get_info
        rescue SchoolFriend::Session::OauthCodeAuthenticationFailedError
            puts "Failed to authenticate oauth code, try again in a few moments..."
        end
    end

    client.puts headers
    client.puts "OK"
    client.close
}
