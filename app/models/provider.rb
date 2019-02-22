class Provider < ApplicationRecord
  belongs_to :version
  has_one_attached :artifact

  validates_presence_of :version

  def self.create_from_params(params, provider_params)
    box = Box.tagged(params[:username], params[:name])
    version = Version.from_box(box).find_by(version: params[:version])

    provider = Provider.new(provider_params)
    provider.version = version

    provider
  end

  def to_h
    { name: name }
  end

  def self.find_from_params(params)
    Provider
      .joins(version: { box: :organization })
      .where(
        versions: { version: params[:version] },
        providers: { name: params[:provider] },
        boxes: { name: params[:name] },
        organizations: { name: params[:username] }
      )
      .first!
  end
end
