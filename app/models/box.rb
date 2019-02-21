class Box < ApplicationRecord
  has_many :versions
  belongs_to :organization

  scope(
    :tagged,
    ->(username, name) { owned_by(username).named(name).first! }
  )

  scope :named, ->(name) { where(name: name) }

  scope(
    :owned_by,
    ->(name) { joins(:organization).where(organizations: { name: name }) }
  )

  def tag
    "#{organization.name}/#{name}"
  end

  def to_h
    { tag: tag, versions: versions_as_hash }
  end

  def versions_as_hash
    return [] if versions.nil? || versions.empty?

    versions.map(&:to_h)
  end
end
