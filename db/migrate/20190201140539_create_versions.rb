class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions do |t|
      t.string :version
      t.text :description, null: true
      t.references :box

      t.boolean :released

      t.timestamps

      t.foreign_key :boxes
    end
  end
end
