class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references :requestor
      t.references :requestee

      t.timestamps
    end
    add_foreign_key :friend_requests, :users, column: :requestor_id
    add_foreign_key :friend_requests, :users, column: :requestee_id
    add_index :friend_requests, [:requestor_id,:requestee_id], unique: true
  end
end
