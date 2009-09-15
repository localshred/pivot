class Main
  MESSAGE_KEY = :messages
  ERROR_KEY = :errors
  
  helpers do

    def tracker
      @tracker ||= Tracker.new
    end
    
    def nice_date(old_date)
      singular = false
      past = false
      
      if old_date.is_a? Time
        old_date = old_date.to_date
      elsif !old_date.is_a? Date
        old_date = Date.parse(old_date)
      end
      
      if Date.today > old_date
        past = true
        diff = (Date.today - old_date).to_i
      else
        diff = (old_date - Date.today).to_i
      end
      
      if diff == 0
        result = 'Today'
        singular = true
      elsif diff == 1
        result = past ? "Yesterday" : "Tomorrow"
        singular = true
      elsif diff <= 7
        result = "#{diff} days"
      elsif diff <= 30
        result = "#{(diff/7).to_i} weeks"
      elsif diff <= 365
        result = "#{(diff/12).to_i} months"
      elsif diff > 365
        result = "#{(diff/365).to_i}+ years"
      end
      result = past && !singular ? result+" ago" : "in "+result
    end
    
    def show_float(float, prec=2)
      float = float.to_f if !float.is_a?(Float)
      float *= 100.0 if float <= 1.0
      sprintf("%.#{prec}f", float)
    end

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
    
    def alt_row_color
      @row = @row == 1 ? 0 : 1
      "alt-row" if @row == 1
    end
    
    def drop_down(options)
      partial :"partials/drop_down", :collection => options[:collection], :name => options[:name], :select => options[:select]
    end

  end
end