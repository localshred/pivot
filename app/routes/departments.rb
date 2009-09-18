# Department specific routes
class Main
  
  # List active departments
  get "/departments/?" do
    @departments = Department.all_sorted
    @page_title = "Departments"
    haml :"departments/index"
  end

  # New department form
  get "/department/new/?" do
    deny_access unless has_role? :admin
    
    @page_title = "New Department"
    haml :"departments/new"
  end
  
  # Create the new department from the post, redirect to show
  post "/department/?" do
    deny_access unless has_role? :admin
    
    @department = Department.create(:name => params[:name], :contact => params[:contact])
    if !@department.errors.empty?
      @department.errors.each {|error| add_error("Please provide a value for #{error}") }
      redirect "/department/new"
    else
      add_message "Succesfully created department #{@department.name}"
      redirect "/department/#{@department.id}"
    end
  end
  
  # Show the department details
  get "/department/:department_id/?" do
    @department = Department.find params[:department_id]
    if @department.nil?
      add_error "Could not find the department with id of #{params[:department_id]}"
      redirect "/departments"
    end
    @page_title = "Showing Department '#{@department.name}'"
    haml :"departments/show"
  end
  
  # Edit the department
  get "/department/:department_id/edit/?" do
    deny_access unless has_role? :admin
    
    @department = Department.find params[:department_id]
    if @department.nil?
      add_error "Could not find the department with id of #{params[:department_id]}"
      redirect "/departments"
    end
    @page_title = "Edit Department '#{@department.name}'"
    haml :"departments/edit"
  end
  
  # Update the department-specific settings
  put "/department/:department_id/?" do
    deny_access unless has_role? :admin
    
    @department = Department.find params[:department_id]
    if @department.nil?
      add_error "Could not find department with id of #{params[:department_id]}"
    else
      @department.name = params[:name]
      @department.contact = params[:contact]
      @department.save
      add_message "Successfully updated department details for #{@department.name}"
    end
    redirect "/department/#{params[:department_id]}"
  end
  
  # Delete Department
  delete "/department/:department_id/?" do
    deny_access unless has_role? :admin
    
    @department = Department.find params[:department_id]
    if @department.nil?
      add_error "Could not find department with id of #{params[:department_id]}"
    else
      name = @department.name
      @department.delete
      @projects = ProjectMeta.find_all_by_department_id params[:department_id]
      @projects.each {|project| project.department_id = nil; project.save} unless @projects.nil? || @projects.empty?
      add_message "Successfully deleted department #{name}"
    end
    redirect "/departments"
  end
  
end
