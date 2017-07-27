class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.datetime :date
      t.binary :thumbnail

      t.timestamps
    end
  end
end
