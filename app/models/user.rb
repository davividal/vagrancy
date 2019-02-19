require 'securerandom'
require 'digest/sha2'

class User < ApplicationRecord
  has_many :boxes
  validates_presence_of :email, :password, :salt

  before_validation :temper

  before_save :hash_password

  private

  def temper
    self.salt = SecureRandom.uuid
  end

  def hash_password
    self.password = Digest::SHA2.base64digest(salt + password)
  end
end
