class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :validatable, :registerable, :lockable, :trackable

  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at sign_in_count_eq sign_in_count_gt sign_in_count_lt]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[id email created_at updated_at sign_in_count_eq sign_in_count_gt sign_in_count_lt]
  end
end
