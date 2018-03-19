class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
        t.string :activity_type
        t.references :user, foreign_key: true
        t.integer :object

        t.timestamps
    end
  end
end
