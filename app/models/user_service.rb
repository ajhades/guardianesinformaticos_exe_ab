# frozen_string_literal: true

class UserService < ApplicationRecord
  belongs_to :user
  belongs_to :service
end
