class CreateBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :boxes do |t|
      t.string :name
      t.references :organization

      t.timestamps

      t.foreign_key :organizations
    end
  end
end
