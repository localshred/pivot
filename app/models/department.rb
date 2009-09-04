class Department < ActiveRecord::Base
  # associations
  has_many :project_meta
  
  # validations
  validates_uniqueness_of :name
  validates_presence_of :name, :contact
end