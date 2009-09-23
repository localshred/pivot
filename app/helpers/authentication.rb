class Main

  helpers do
    
    # Checks the request path to determine if the user needs to login
    def login_required?(request_path)
      protected_pages.any?{|pattern| request_path =~ Regexp.new(pattern)}
    end

    # A list of pages that require basic login authentication
    def protected_pages
      %w{ ^\/projects? ^\/developers? ^\/departments? ^\/logout ^\/$ }
    end

    # Get the current user
    def current_user
      session[:user]
    end

    # Check if the user is logged in
    def logged_in?
      !current_user.nil?
    end
    
    # Log the user in
    def login_user(options={})
      return if logged_in?
      
      default_user = {
        :username => nil,
        :password => nil,
        :token => nil,
        :roles => nil
      }
        
      session[:user] = default_user.merge!(options)
      assign_roles(options[:username])
    end
    
    # Log the user out
    def logout_user
      session[:user] = nil
    end
    
    # Check if a user has a particular role
    def has_role?(role = nil)
      logged_in? && (current_user[:roles].include?(:admin) || current_user[:roles].include?(role.to_sym))
    end
    
    def deny_access(silent=true)
      add_error "You do not have sufficient privileges to perform that action." unless silent
      redirect request.referer || "/" # designated "safe" url, where we shouldn't have any role requirements (beyond login)
    end
    
    def assign_roles(username)
      unless settings(:roles).nil?
        current_user[:roles] = settings(:roles).map do |role, users|
          role if users.nil? || users.empty? || users.include?(username)
        end
      else
        current_user[:roles] = [:user]
      end
    end
    
  end
  
end
