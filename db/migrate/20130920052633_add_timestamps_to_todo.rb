class AddTimestampsToTodo < ActiveRecord::Migration
  def change
  	add_column :todos, :created_at, :datetime
  	add_column :todos, :updated_at, :datetime
  end
end
