class ApiRequest < ApplicationRecord
  validates :address, presence: true

  scope :in_last_hours, -> (x) {where("created_at >= ? ", x.hour.ago)}
end
