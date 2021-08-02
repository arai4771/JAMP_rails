class User < ApplicationRecord
  has_secure_password

  validates :name, {presence: true,length: {maximum:10}}

  validates :career, {presence: true,length: {maximum:200}}

  def posts
    return Post.where(user_id: self.id)
  end 

end
