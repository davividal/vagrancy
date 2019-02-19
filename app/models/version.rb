class Version < ApplicationRecord
  belongs_to :box
  has_many :providers

  scope :from_box, ->(box) { joins(:box).where(box: box) }

  def to_h
    { version: version }
  end

  def release!
    self.released = true
    save!
  end

  def self.find_from_params(params)
    Version
      .joins(box: :user)
      .where(
        version: params[:version],
        boxes: { name: params[:name] },
        users: { username: params[:username] }
      )
      .first!
  end

  def self.create_from_params(params, version_params)
    box = Box.owned_by(params[:username]).named(params[:name]).first

    version = Version.new(version_params)
    version.box = box

    version
  end
end
