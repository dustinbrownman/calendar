class AddNotableIdToNotes < ActiveRecord::Migration
  def change
  	add_reference :notes, :notable, polymorphic: true
  end
end
