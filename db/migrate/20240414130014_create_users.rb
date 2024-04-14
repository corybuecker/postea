# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_enum :users_external_provider, ["google"]

    create_table :users do |t|
      t.string :email, null: false
      t.enum :external_provider, enum_type: "users_external_provider", null: false
      t.string :external_id, null: false
      t.string :image, null: true

      t.timestamps
    end
  end
end
