require 'securerandom'
require 'digest/sha2'

class User < ApplicationRecord
  has_many :boxes
  has_and_belongs_to_many :organizations

  validates_presence_of :email, :password, :salt

  before_validation :temper

  before_save :hash_password
  after_save :create_user_organization

  private

  def temper
    self.salt = SecureRandom.uuid
  end

  def hash_password
    self.password = Digest::SHA2.base64digest(salt + password)
  end

  def create_user_organization
    organizations.create(name: username)
  end
end
