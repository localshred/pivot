class Main
  MESSAGE_KEY = :messages
  ERROR_KEY = :errors
  
  helpers do

    def tracker
      @tracker ||= Tracker.new
    end
    
    def nice_date(old_date)
      diff = (Date.today - old_date).to_i
      if diff == 0
        result = 'Today'
      elsif diff == 1
        result = "Yesterday"
      elsif diff <= 7
        result = "#{diff} days ago"
      elsif diff <= 30
        result = "#{(diff/7).to_i} weeks ago"
      elsif diff <= 365
        result = "#{(diff/12).to_i} months ago"
      elsif diff > 365
        result = "#{(diff/365).to_i}+ years ago"
      end
      result
    end

    # MESSAGES
    def add_message(msg)
      clear_session_messages if !session_has_messages? # gives us a fresh array
      session[MESSAGE_KEY] << msg.to_s # ensure it's a string message
    end

    def show_session_messages
      messages = session[MESSAGE_KEY]
      clear_session_messages
      partial :show_messages, :messages => messages, :message_class => "messages" if session_has_messages?
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
      partial :show_messages, :messages => messages, :message_class => "errors" if session_has_errors?
    end
    
    def session_has_errors?
      (session.key?(ERROR_KEY) && !session[ERROR_KEY].empty?)
    end
    
    def clear_session_errors
      session[ERROR_KEY] = []
    end

  end
end
