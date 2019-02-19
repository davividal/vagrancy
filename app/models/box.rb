class Box < ApplicationRecord
  has_many :versions
  belongs_to :user

  scope(
    :tagged,
    ->(username, name) { owned_by(username).named(name).first! }
  )

  scope :named, ->(name) { where(name: name) }

  scope(
    :owned_by,
    ->(username) { joins(:user).where(users: { username: username }) }
  )

  def tag
    "#{user.username}/#{name}"
  end

  def to_h
    { tag: tag, versions: versions }
  end

  def versions
    return [] if @versions.nil? || @versions.empty?

    @versions.each(&:to_h)
  end
end
