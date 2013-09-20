class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
    	t.column :body, :text

    	t.timestamps
    end
  end
end
