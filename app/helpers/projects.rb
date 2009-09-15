class Main
  helpers do
    
    def show_date(datetime)
      if (datetime.nil?)
        haml "%span.emphasis none", :layout => false
      else
        if datetime.is_a? Date
          datetime = datetime.to_time
        elsif datetime.is_a? String
          datetime = Date.parse(datetime)
        elsif !datetime.is_a? Time
          raise ArgumentError, "Invalid object passed to show_date"
        end
        full_date = datetime.strftime("%m-%d-%Y")
        haml "%span{:title => \"#{full_date}\"} #{nice_date(datetime)}", :layout => false
      end
    end
    
    def archive_action(is_active)
      is_active ? "archive" : "unarchive"
    end
    
    def has_stories?(project)
      (project.num_stories > 0)
    end
    
    def has_open_stories?(project)
      (!project.nil? && has_stories?(project) && project.completion_ratio < 100.00)
    end
    
    def all_stories_completed?(project)
      !has_open_stories? project
    end
    
    def external_project_link(project)
       "http://www.pivotaltracker.com/projects/#{project.project_id}"
    end
    
    
  end
end