# Generic HTTP wrapper to make calls to the API
module APIConnector
  class Response
    attr_reader :headers, :body, :error_message
    
    def initialize(options={})
      @headers = options[:headers] || nil
      @body = options[:body] || nil
      @error_message = options[:error_message] || nil
    end
    
    def to_h
      Hpricot(@body)
    end
    
    def error?
      @connection_error
    end
  
  end
end