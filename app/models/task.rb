class Task < ApplicationRecord
  belongs_to :user
  belongs_to :diary

  validates :content, presence: true
  validates :user_id, presence: true
end
