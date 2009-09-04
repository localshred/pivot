class Main
  helpers do

    def link_to_department(department)
      if department.nil?
        haml "%span.emphasis none", :layout => false
      else
        haml "%a{:href => \"/department/#{department.id}\", :title => \"View Department #{department.name}\"} #{department.name}", :layout => false
      end
    end
    
  end
end
