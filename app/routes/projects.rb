# Project specific routes
class Main
  
  # List active Projects
  ["/", "/projects/?", "/projects/archive/?"].each do |path|
    get path do
      # Filter the projects based on active status and archive_view
      @archive_view = path =~ /archive/ ? true : false
      @page_title = "#{@archive_view ? "Archived" : "Active"} Projects"
      @projects = ProjectMeta.find_local !@archive_view
      add_error "No projects found" if @projects.nil? || @projects.empty?
      haml :"projects/index"
    end
  end
  
  # Synchronize all projects (get all new)
  get "/projects/sync/?" do
    @page_title = "Synchronizing with Pivotal API..."
    tracker.projects
    add_message "Successfully synced new projects from the API."
    redirect "/projects"
  end
  
  # Synchronize single project
  get "/project/:project_meta_id/sync/?" do
    @page_title = "Synchronizing with Pivotal API..."
    @project = ProjectMeta.find params[:project_meta_id]
    unless @project.nil?
      Tracker.new.project @project.project_id
      add_message "Successfully synced project #{params[:project_meta_id]} with the API."
      redirect "/project/#{params[:project_meta_id]}"
    else
      redirect "/projects"
    end
  end
  
  # Show the project details
  get "/project/:project_meta_id/?" do
    @project = ProjectMeta.find params[:project_meta_id]
    if @project.nil?
      add_error "Could not find that project"
      redirect "/projects"
    end
    @page_title = "Showing Project '#{@project.name}'"
    haml :"projects/show"
  end
  
  # Edit the project
  get "/project/:project_meta_id/edit/?" do
    @project = ProjectMeta.find params[:project_meta_id]
    if @project.nil?
      add_error "Could not find that project"
      redirect "/projects"
    end
    @page_title = "Edit Project '#{@project.name}'"
    haml :"projects/edit";
  end
  
  # Update the project-specific settings
  put "/project/:project_meta_id/?" do
    @project = ProjectMeta.find params[:project_meta_id]
    unless @project.nil?
      @project.developer_id = params[:developer_id]
      @project.department_id = params[:department_id]
      @project.original_target_date = nil if params.include?("clear_original_target_date")
      @project.original_target_date = params[:original_target_date].strip unless !params.include?("original_target_date") || params["original_target_date"].strip.empty?
      @project.save!
      add_message "Successfully updated project settings."
    else
      add_error "Could not find project #{params[:project_meta_id]}"
    end
    redirect "/project/#{@project.id}"
  end
  
  put "/project/:project_meta_id/archive/?" do
    @project = ProjectMeta.find params[:project_meta_id]
    unless @project.nil?
      @project.is_active = false
      @project.save!
      add_message "Successfully archived project #{@project.name}"
      redirect "/project/#{@project.id}"
    else
      redirect "/projects"
    end
  end
  
  put "/project/:project_meta_id/unarchive/?" do
    @project = ProjectMeta.find params[:project_meta_id]
    unless @project.nil?
      @project.is_active = true
      @project.save
      add_message "Successfully un-archived project #{@project.name}"
      redirect "/project/#{@project.id}"
    else
      redirect "/projects/archive"
    end
  end
  
end
