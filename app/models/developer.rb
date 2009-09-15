class Developer < ActiveRecord::Base
  # associations
  has_many :active_projects, :class_name => "ProjectMeta", :order => "name", :conditions => ["project_meta.is_active = ?", true]
  
  # scopes
  named_scope :all_sorted, :include => :active_projects, :order => "name ASC"
  
  # validations
  validates_uniqueness_of :name
  validates_presence_of :name, :email
  
  def first_name
    name.split(" ").first
  end
  
end