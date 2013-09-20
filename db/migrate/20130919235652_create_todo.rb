class CreateTodo < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :description
      t.boolean :complete
    end
  end
end
