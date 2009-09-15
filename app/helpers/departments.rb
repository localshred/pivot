class Main
  helpers do

    def link_to_department(department)
      if department.nil?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"/department/#{department.id}\", :title => \"View Department #{department.name}\"} #{department.name}", :layout => false
      end
    end
    
    def departments_drop_down(option_to_select=nil)
      departments = Department.all_sorted.map{|department| {:key => department.id, :value => department.name} }
      drop_down :collection => departments, :name => "department_id", :select => option_to_select
    end
    
  end
end
