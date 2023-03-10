class User < ApplicationRecord
  # add the revocation strategy to the model class and configure accordingly
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # def generate_jwt
  #   JWT.encode( {id: id, exp: 60.days.from_now.to_i}, Rails.application)
  # end

  has_one :profile, dependent: :destroy

  # the revocation strategy makes uses of jwt_payload method in the user model
  # def jwt_payload
  #   super.merge('foo' => 'bar')
  # end
end
