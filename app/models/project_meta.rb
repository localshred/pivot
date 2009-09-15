class ProjectMeta < ActiveRecord::Base
  set_table_name "project_meta"
  
  # associations
  belongs_to :developer
  belongs_to :department
  
  # validations
  validates_uniqueness_of :project_id
  validates_presence_of :name
  validates_numericality_of :project_id
  validates_numericality_of :developer_id, :department_id, :num_stories, :num_completed_stories, { :allow_nil => true }
  
  # named scopes
  named_scope :all_sorted, :order => "current_target_date ASC, name ASC"
  named_scope :active, :conditions => {:is_active => true}
  named_scope :inactive, :conditions => {:is_active => false}
  
  # static methods
  def self.create_from_project(project)
    meta = ProjectMeta.new
    meta.project_id = project.id
    meta.name = project.name
    meta.num_stories = project.num_stories
    meta.num_completed_stories = project.num_completed_stories
    meta.completion_ratio = ProjectMeta.calculate_ratio(project.num_completed_stories, project.num_stories)
    meta.current_target_date = project.current_target_date
    meta.save!
    meta
  end
  
  def self.find_local(is_active=nil)
    case is_active
    when true
      ProjectMeta.all_sorted.active
    when false
      ProjectMeta.all_sorted.inactive
    when nil
      ProjectMeta.all_sorted
    end
  end
  
  # instance methods
  def developer
    Developer.find developer_id if !developer_id.nil?
  end
  
  def department
    Department.find department_id if !department_id.nil?
  end
  
  def sync(project)
    raise ArgumentError, "Cannot sync with invalid project object" if project.nil? || !project.is_a?(Project)
    self[:name] = project.name
    self[:num_stories] = project.stories.size
    self[:num_completed_stories] = project.num_completed_stories
    self[:completion_ratio] = ProjectMeta.calculate_ratio(self[:num_completed_stories], self[:num_stories])
    self[:current_target_date] = project.current_target_date
    self.save!
  end
  
  def self.calculate_ratio(numerator, divisor)
    numerator = numerator.to_f if !numerator.is_a?(Float)
    divisor = divisor.to_f if !divisor.is_a?(Float)
    result = divisor > 0.0 ? numerator/divisor : 0.0
    result *= 100 if result <= 1.0
  end
  
end