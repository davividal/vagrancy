class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :url
      t.string :hosted_token
      t.string :upload_url
      t.references :version

      t.timestamps
    end
  end
end
