class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    # CREATE EXTENSION pgroonga;
    enable_extension 'pgroonga'

    create_table :articles do |t|
      t.string :title
      t.text   :abstract # 摘要
      t.string :url

      t.timestamps
    end
  end
end
