class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :text
      t.string :stag
      t.string :status_id
      t.references :user, index: true
      t.string :raw_data

      t.timestamps
    end
  end
end
