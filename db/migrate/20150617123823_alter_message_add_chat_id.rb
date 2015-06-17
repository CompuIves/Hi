class AlterMessageAddChatId < ActiveRecord::Migration
  def change
    add_column :messages, :chat_id, :integer
    add_foreign_key :messages, :chats
  end
end
