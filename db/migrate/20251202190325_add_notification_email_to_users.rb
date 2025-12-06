class AddNotificationEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notification_email, :string, default: nil
  end
end
