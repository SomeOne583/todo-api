class CreateNotificationPanels < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_panels do |t|
      t.string :notification
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
