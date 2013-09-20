class Note < ActiveRecord::Base

	validates :body, presence: true

	belongs_to :notable, polymorphic: true

end