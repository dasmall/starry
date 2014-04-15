class CreateFavoriteCategories < ActiveRecord::Migration
  def change
    create_table :favorite_categories do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
