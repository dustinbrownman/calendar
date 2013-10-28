class Todo < ActiveRecord::Base
  validates :description, presence: true

  has_many :notes, as: :notable
end
