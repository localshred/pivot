# Generic HTTP wrapper to make calls to the API
module APIConnector
  attr_accessor :request, :response
  attr_reader :error_message
  
  def connect(options={})
    raise(ArgumentError, "You must specify a path to connect to") if !options.include?(:path)
    begin
      @request = APIConnector::Request.new(options)
      @response = @request.connect
    rescue Timeout::Error
      @error_message = "Connection timed out"
    end
  end
  
  def error?
    !@error_message.nil?
  end
  
end