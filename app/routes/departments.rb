# Department specific routes
class Main
  
  # List active departments
  get "/departments/?" do
    @departments = Department.all
    haml :"departments/index"
  end

  # New department form
  get "/department/new/?" do
    haml :"departments/new"
  end
  
  # Create the new department from the post, redirect to show
  post "/department/?" do
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
    @department = Department[params[:department_id]]
    haml :"departments/show"
  end
  
  # Edit the department
  get "/department/:department_id/edit/?" do
    @department = Department[params[:department_id]]
    if @department.nil?
      add_error "Could not find the department with id of #{params[:department_id]}"
      redirect "/departments"
    end
    haml :"departments/edit"
  end
  
  # Update the department-specific settings
  put "/department/:department_id/?" do
    @department = Department[params[:department_id]]
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
    @department = Department[params[:department_id]]
    if @department.nil?
      add_error "Could not find department with id of #{params[:department_id]}"
    else
      name = @department.name
      @department.delete
      add_message "Successfully deleted department #{name}"
    end
    redirect "/departments"
  end
  
end
