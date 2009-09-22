class Main
  
  # Before filter
  before do
    # Ensure user is logged in if need be
    if !logged_in? && login_required?(request.path_info)
      session[:login_redirect] = request.path_info
      add_message "Please login to perform that action."
      redirect "/login"
    end
  end
  
  get "/login" do
    redirect "/projects" if logged_in?
    
    haml :"application/login"
  end
  
  post "/login/?" do
    if !params[:username].strip.empty? && !params[:password].strip.empty?
      # Build the temporary options hash
      params[:username].strip!
      params[:password].strip!
      user_options = {
        :username => params[:username].strip,
        :password => params[:password].strip,
      }
      
      # Attempt to get an api token with the credentials
      begin
        token = Token.new(user_options)
      rescue Exception => e
        add_error "Authentication failed. Please try again."
        redirect "/login"
        puts "Auth failed! -> #{e.message}"
        return # ensure no weirdness
      end
      
      # Assign the token
      user_options[:token] = token
      
      # Log the user in
      login_user user_options
      
      # Handle redirects from the session, accounting for /logout in the path
      login_redirect = session[:login_redirect] =~ /^\/logout/ ? nil : session[:login_redirect]
      session[:login_redirect] = nil
    
      add_message "You were successfully logged in."
      redirect login_redirect || "/"
    else
      add_error "Please provide your username." if params[:username].strip.empty?
      add_error "Please provide your password." if params[:password].strip.empty?
      redirect "/login"
    end
  end
  
  get "/logout/?" do
    redirect "/login" if !logged_in?
    
    session[:user] = nil unless current_user.nil?
    add_message "You were successfully logged out."
    redirect "/login"
  end
  
  get "/about/?" do
    haml :"application/about"
  end
end