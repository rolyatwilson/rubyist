module SoTimely
  class CanvasAPI
    attr_reader :domain, :token
    def initialize
      config  = Config.new
      @domain = config.domain
      @token  = config.token
    end

    def create_course(course_args)
      uri          = URI.parse("#{domain}accounts/self/courses")
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request      = Net::HTTP::Post.new(uri)
      request['authorization'] = "Bearer #{token}"
      request['content-type']  = 'application/x-www-form-urlencoded'
      request.body = URI.encode_www_form(course_args)
      response     = http.request(request)
      JSON.parse(response.body).deep_symbolize_keys!
    end
  end
end
