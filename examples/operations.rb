#!/usr/bin/env ruby

require 'logger'
require 'yaml'
require 'school_friend'
require 'time'
require 'socket'

log = Logger.new(STDOUT)
log.level = Logger::INFO

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

example_settings = YAML.load_file(File.dirname(__FILE__) + '/examples_settings.yaml')

puts "Login using Odnoklassniki: \"#{example_settings['oauth_server']}/oauth/authorize?client_id=#{example_settings['application_id']}&scope=#{example_settings['permission']}&response_type=code&redirect_uri=http://127.0.0.1:#{example_settings['listener_port']}\""

def operation_pretty_print title, result
    puts "*" * 80
    puts title
    puts "*" * 80

    puts ""
    begin
        puts JSON.pretty_generate(result)
    rescue JSON::GeneratorError
        puts result
    end
end

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
            session.refresh_access_token

            current_user = session.users.get_current_user
            operation_pretty_print "users.get_current_user", current_user
            operation_pretty_print "friends.get_app_users (Returns IDs of users who are friends of the current user and authorize the calling application)", session.friends.get_app_users
            operation_pretty_print "friends.get", friends = session.friends.get

            operation_pretty_print "users.get_info", session.users.get_info(:uids => friends.join(","), :fields => "uid,first_name,last_name,name,gender,birthday,age,locale,location,current_location,current_status,current_status_id,current_status_date,online,pic_1,pic_2,pic_3,pic_4,pic_5,url_profile,url_profile_mobile,url_chat,url_chat_mobile,has_email,allows_anonym_access")

            operation_pretty_print "discussions.get_list", session.discussions.get_list

            status = "Cool Status #{Random.rand(0...1000)}"
            operation_pretty_print "users.set_status - #{status}", session.users.set_status(:status => status)

            message = "Cool Message #{Random.rand(0...1000)}"
            operation_pretty_print "share.add_link - #{message}", session.share.add_link(:comment => message, :linkUrl => "http://www.imdb.com/title/tt0110413/")
            message = "Cool Message #{Random.rand(0...1000)}"
            operation_pretty_print "share.add_link - #{message}", session.share.add_link(:comment => message, :linkUrl => "http://www.imdb.com/title/tt0137523/")
            message = "Cool Message #{Random.rand(0...1000)}"
            operation_pretty_print "share.add_link - #{message}", session.share.add_link(:comment => message, :linkUrl => "http://www.youtube.com/watch?v=wxaFANthouM")

            operation_pretty_print "users.get_calls_left", session.users.get_calls_left(:methods => "users.getInfo,stream.publish")
        rescue SchoolFriend::Session::OauthCodeAuthenticationFailedError
            puts "Failed to authenticate oauth code, try again in a few moments..."
        end
    end

    client.puts headers
    client.puts "OK"
    client.close
}
