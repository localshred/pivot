class Main
  
  helpers do

    def tracker
      @tracker ||= Tracker.new(current_user[:token].is_a?(Token) ? current_user[:token] : Token.new(current_user))
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
      elsif diff <= 28
        result = "#{(diff/7).to_i} weeks"
      elsif diff <= 365
        num_months = (diff/30).to_i
        if (diff%30) > 0
          num_months = Float(num_months)
          num_months += (Float(diff)%Float(30))/Float(30)
          num_months = sprintf("%.1f", num_months)
        end
        result = "#{num_months} months"
      elsif diff > 365
        result = "#{(diff/365).to_i}+ years"
      end
      result = (singular ? result : (past ? result+" ago" : "in "+result))
    end
    
    def show_float(float, prec=2)
      float = float.to_f if !float.is_a?(Float)
      float *= 100.0 if float <= 1.0
      sprintf("%.#{prec}f", float)
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