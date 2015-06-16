class RemoveUserIdFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :user_id
  end
end
