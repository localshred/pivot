class CreateTables
  def self.up
    begin
      ActiveRecord::Schema.define(:version => 1) do
        # project_meta table
        create_table :project_meta do |t|
          t.integer :project_id, :null => false
          t.integer :developer_id
          t.integer :department_id
          t.datetime :original_target_date
          t.datetime :current_target_date
          t.integer :num_stories, :default => 0
          t.integer :num_completed_stories, :default => 0
          t.float :completion_ratio, :default => 0.0
          t.boolean :is_active, :default => 1
        end
        add_index :project_meta, :project_id, :unique => true
        add_index :project_meta, :developer_id
        add_index :project_meta, :department_id
      
        # developers table
        create_table :developers do |t|
          t.string :name, :null => false
          t.string :email
          t.boolean :is_active, :default => 1
        end
        add_index :developers, :name, :unique => true
      
        # departments table
        create_table :departments do |t|
          t.string :name, :null => false
          t.string :contact
          t.boolean :is_active, :default => 1
        end
        add_index :departments, :name, :unique => true
      
      end
    rescue Exception => e
      puts e
    end
  end

  def self.down
    drop_table :project_meta
    drop_table :developers
    drop_table :departments
  end

  def self.tables_exist?
    ProjectMeta.table_exists? && Developer.table_exists? && Department.table_exists?
  end

end
