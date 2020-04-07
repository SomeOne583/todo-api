class User < ApplicationRecord
    include Devise::JWT::RevocationStrategies::JTIMatcher

    has_many :todos
    has_many :notification_panels

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :jwt_authenticatable, jwt_revocation_strategy: self
end
