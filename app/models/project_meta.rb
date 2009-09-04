class ProjectMeta < ActiveRecord::Base
  set_table_name "project_meta"
  # associations
  belongs_to :developer
  belongs_to :department
  
  # validations
  validates_uniqueness_of :project_id
  validates_numericality_of :project_id, :developer_id, :department_id, :num_stories, :num_completed_stories
  
  def self.create_from_project(project)
    ProjectMeta.create({
      :project_id => project.id,
      :num_stories => project.num_stories,
      :num_completed_stories => project.num_completed_stories
    })
  end
  
  def developer
    Developer[developer_id] if !developer_id.nil?
  end
  
  def department
    Department[department_id] if !department_id.nil?
  end
  
  # def current_target_date=(project)
  #   self.current_target_date = project.current_target_date
  # end
  # 
  # def num_stories=(project)
  #   self.num_stories = project.stories.size
  # end
  # 
  # def num_completed_stories=(project)
  #   self.num_completed_stories = project.num_completed_stories
  # end
  
  def completion_ratio=(project)
    self.completion_ratio = 0
    self.completion_ratio = (project.num_completed_stories/project.num_stories) if num_stories.to_i > 0
  end
  
  def original_target_date=(date)
    raise ArgumentError, "Cannot change original target date, it has already been changed"
    self.original_target_date = date
  end
  
  def sync(project)
    raise ArgumentError, "Cannot sync with invalid project object" if project.nil? || !project.is_a?(Project)
    num_stories = project
    num_completed_stories = project
    completion_ratio = project
    current_target_date = project
  end
  
end