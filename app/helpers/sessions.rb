class Main
  MESSAGE_KEY = :messages
  ERROR_KEY = :errors
  
  helpers do
    
    # MESSAGES
    def add_message(msg)
      clear_session_messages if !session_has_messages? # gives us a fresh array
      session[MESSAGE_KEY] << msg.to_s # ensure it's a string message
    end

    def show_session_messages
      messages = session[MESSAGE_KEY]
      clear_session_messages
      partial :"partials/show_messages", :messages => messages, :message_class => "messages" unless messages.nil? || messages.empty?
    end
    
    def session_has_messages?
      (session.key?(MESSAGE_KEY) && !session[MESSAGE_KEY].empty?)
    end
    
    def clear_session_messages
      session[MESSAGE_KEY] = []
    end

    # ERRORS
    def add_error(error)
      clear_session_errors if !session_has_errors? # gives us a fresh array
      session[ERROR_KEY] << error.to_s # ensure it's a string error
    end

    def show_session_errors
      messages = session[ERROR_KEY]
      clear_session_errors
      partial :"partials/show_messages", :messages => messages, :message_class => "errors" unless messages.nil? || messages.empty?
    end
    
    def session_has_errors?
      (session.key?(ERROR_KEY) && !session[ERROR_KEY].empty?)
    end
    
    def clear_session_errors
      session[ERROR_KEY] = []
    end
    
  end
  
end