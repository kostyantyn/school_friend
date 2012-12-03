module SchoolFriend
  module APIMethods
    class << self
      def included(base)
        base.extend(ClassMethods)
        base.send(:attr_reader, :session)
      end
    end

    module ClassMethods
      def api_method(*methods)
        options = methods.last.is_a?(Hash) ? methods.pop : {}

        namespace    = name.sub(/^.+::/, '')
        namespace[0] = namespace[0].downcase

        methods.each do |method|
          call  = "session.api_call('#{namespace}.#{method.to_s.gsub(/_([a-z])/) { $1.upcase }}', params"
          call += options[:session_only] ? ', true)' : ')'

          class_eval <<-OES, __FILE__, __LINE__ + 1
            def #{method}(params = {})             # def get_widgets(params = {})
              response = #{call}                   #   response = session.api_call('widget.getWidgets', params, true)
              if response.is_a?(Net::HTTPSuccess)  #   if response.is_a?(Net::HTTPSuccess)
                JSON(response.body)                #     JSON(response.body)
              else                                 #   else
                response.error!                    #     response.error!
              end                                  #   end
            end                                    # end
          OES
        end
      end
    end

    def initialize(session)
      @session = session
    end
  end
end