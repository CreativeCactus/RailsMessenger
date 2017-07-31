class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.integer :to_id, null: false
      t.integer :from_id, null: false

      t.timestamps
    end
  end
end
