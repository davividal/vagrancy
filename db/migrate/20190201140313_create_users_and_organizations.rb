class CreateUsersAndOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :salt

      t.timestamps

      t.index :username, unique: true
    end

    create_table :organizations do |t|
      t.string :name

      t.timestamps

      t.index :name, unique: true
    end

    create_table :organizations_users, id: false do |t|
      t.belongs_to :organization, index: true, null: false
      t.belongs_to :user, index: true, null: false

      t.foreign_key :organizations
      t.foreign_key :users
    end
  end
end
