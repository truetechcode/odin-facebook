class CreatePics < ActiveRecord::Migration[5.2]
  def change
    create_table :pics do |t|
      t.references :author, index: true

      t.timestamps
    end
    add_foreign_key :pics, :users, column: :author_id
  end
end
