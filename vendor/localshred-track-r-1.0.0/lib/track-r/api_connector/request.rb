module APIConnector
  class Request
    attr_reader :token, :path, :headers, :body, :connection_length, :error_message
  
    def initialize(options={})
      @token = options[:token] || Token.new
      @path = options[:path] || "/"
      @connection_length = options[:connection_length].to_i || 15 # timeout
      @headers = default_headers.merge! options
    end
  
    def connect
      Timeout::timeout(@connection_length) {
        return APIConnector::Response.new(:body => open(api_url, @headers))
      }
    end
  
    def error?
      !@error_message.nil?
    end
  
    private
  
    def default_headers
      {
        "X-TrackerToken" => @token.to_s
      }
    end
    
  end
end