class Main
  helpers do

    def link_to_developer(developer)
      if developer.nil?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"/developer/#{developer.id}\", :title => \"View Developer #{developer.name}\"} #{developer.name}", :layout => false
      end
    end
    
    def show_email(developer)
      if developer.email.nil? || developer.email.strip.empty?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"mailto:#{developer.email}\", :title => \"Contact #{developer.name}\"} #{developer.email}", :layout => false
      end
    end
    
  end
end
