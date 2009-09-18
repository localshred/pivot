# Developer specific routes
class Main
  
  # List active developers
  get "/developers/?" do
    @developers = Developer.all_sorted
    @page_title = "Developers"
    haml :"developers/index"
  end
  
  # New developer form
  get "/developer/new/?" do
    deny_access unless has_role? :admin
    
    @page_title = "New Developer"
    haml :"developers/new"
  end
  
  # Create the new developer from the post, redirect to show
  post "/developer/?" do
    deny_access unless has_role? :admin
    
    @developer = Developer.create(:name => params[:name], :email => params[:email], :is_active => true)
    if !@developer.errors.empty?
      @developer.errors.each {|error| add_error("Please provide a value for #{error}") }
      redirect "/developer/new"
    else
      add_message "Successfully created developer #{@developer.name}"
      redirect "/developer/#{@developer.id}"
    end
  end
  
  # Show the developer details
  get "/developer/:developer_id/?" do
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find developer with id #{params[:developer_id]}"
      redirect "/developers"
    end
    @page_title = "Showing Developer '#{@developer.name}'"
    haml :"developers/show"
  end
  
  # Edit the developer
  get "/developer/:developer_id/edit/?" do
    
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find the developer with id of #{params[:developer_id]}"
      redirect "/developers"
    end
    
    deny_access unless has_role?(:admin) || user_is_dev?(@developer)
    
    @page_title = "Edit Developer '#{@developer.name}'"
    haml :"developers/edit"
  end
  
  # Update the developer-specific settings
  put "/developer/:developer_id/?" do
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find Developer with id of #{params[:developer_id]}"
    else
      deny_access unless has_role?(:admin) || user_is_dev?(@developer)
      
      email_changed = (@developer.email != params[:email].strip)
      @developer.name = params[:name].strip
      @developer.email = params[:email].strip
      @developer.save
      add_message "Successfully updated developer details for #{@developer.name}"
      
      if email_changed && user_is_dev?(@developer)
        logout_user
        add_message "You have been logged out because you changed your username (email). Please login again."
        redirect "/login"
      end
    end
    redirect "/developer/#{params[:developer_id]}"
  end
  
  delete "/developer/:developer_id/?" do
    deny_access unless has_role? :admin
    
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find Developer with id of #{params[:developer_id]}"
    else
      name = @developer.name
      @developer.delete
      @projects = ProjectMeta.find_all_by_developer_id params[:developer_id]
      @projects.each {|project| project.developer_id = nil; project.save} unless @projects.nil? || @projects.empty?
      add_message "Successfully deleted developer #{name}"
    end
    redirect "/developers"
  end
  
end
