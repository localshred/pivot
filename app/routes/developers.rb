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
    @page_title = "New Developer"
    haml :"developers/new"
  end
  
  # Create the new developer from the post, redirect to show
  post "/developer/?" do
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
    @page_title = "Edit Developer '#{@developer.name}'"
    haml :"developers/edit"
  end
  
  # Update the developer-specific settings
  put "/developer/:developer_id/?" do
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find Developer with id of #{params[:developer_id]}"
    else
      @developer.name = params[:name]
      @developer.email = params[:email]
      @developer.save
      add_message "Successfully updated developer details for #{@developer.name}"
    end
    redirect "/developer/#{params[:developer_id]}"
  end
  
  delete "/developer/:developer_id/?" do
    @developer = Developer.find params[:developer_id]
    if @developer.nil?
      add_error "Could not find Developer with id of #{params[:developer_id]}"
    else
      name = @developer.name
      @developer.delete
      add_message "Successfully deleted developer #{name}"
    end
    redirect "/developers"
  end
  
end
