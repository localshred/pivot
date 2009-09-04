# Project specific routes
class Main
  
  # List active Projects
  ["/", "/projects/?"].each do |path|
    get path do
      @projects = tracker.projects
      haml :"projects/index"
    end
  end
  
  # List archived projects
  get "/projects/archive/?" do
    @archive_view = true
    @projects = []
    haml :"projects/index"
  end
  
  # Show the project details
  get "/project/:project_id/?" do
    @project = Project.new(:project_id => params[:project_id])
    haml :"projects/show"
  end
  
  # Edit the project
  get "/project/:project_id/edit/?" do
    @project = Project.new(:project_id => params[:project_id])
    haml :"projects/edit"
  end
  
  # Update the project-specific settings
  put "/project/:project_id/update/?" do
    redirect "/project/#{params[:project_id]}?update=true"
  end
  
  # Archive the project (xhr request)
  put "/project/:project_id/archive/?" do
    # TODO archive the project in the db
    haml '.success Project successfully archived', :layout => false
  end
  
end
