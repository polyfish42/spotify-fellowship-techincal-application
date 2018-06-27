class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title, default: "Untitled"
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.text :description

      t.timestamps
    end
  end
end
