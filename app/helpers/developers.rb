require "cgi"

class Main
  helpers do

    def link_to_developer(developer, short=true)
      if developer.nil?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"/developer/#{developer.id}\", :title => \"View Developer #{developer.name}\"} #{short ? developer.first_name : developer.name}", :layout => false
      end
    end
    
    def show_email(developer)
      if developer.email.nil? || developer.email.strip.empty?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"mailto:#{developer.email}\", :title => \"Contact #{developer.name}\"} #{developer.email}", :layout => false
      end
    end
    
    def developers_drop_down(option_to_select=nil)
      developers = Developer.all_sorted.map{|developer| {:key => developer.id, :value => developer.name} }
      drop_down :collection => developers, :name => "developer_id", :select => option_to_select
    end
    
    def notify_developer_link(project)
      return if project.nil?
      params = {
        "subject" => "Provide Stories for Project",
        "body" => "Please provide stories for pivotal project #{external_project_link(project)}"
      }
      query_string = params.map{|key, val| "#{key}=#{CGI::escape(val)}" }.join("&")
      haml "%a{:href => \"mailto:#{project.developer.email}?#{query_string}\", :title => \"Notify Developer to provide stories for project\"} Notify Developer", :layout => false
    end
    
    def user_is_dev?(developer)
      !developer.nil? && !developer.email.nil? && !current_user.nil? && developer.email == current_user[:username]
    end
    
  end
end
