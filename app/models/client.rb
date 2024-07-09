class Client < ApplicationRecord
  has_many :users
  has_many :services
  validates :name, presence: true
  validates :nit, presence: true
end
