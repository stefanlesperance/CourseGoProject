class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #Course is pluralized 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :courses
  def to_s
    email
  end
end
