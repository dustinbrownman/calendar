class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :description
      t.string :location
      t.timestamp :start_timestamp
      t.timestamp :end_timestamp
      t.text :notes
    end
  end
end
