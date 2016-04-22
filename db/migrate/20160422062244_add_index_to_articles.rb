class AddIndexToArticles < ActiveRecord::Migration[5.0]
  def change
    add_index :articles, :abstract, using: :pgroonga
  end
end
