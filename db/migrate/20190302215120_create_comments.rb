class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :post, foreign_key: true
      t.references :author, index: true

      t.timestamps
    end
    add_foreign_key :comments, :users, column: :author_id
  end
end
