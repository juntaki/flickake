class AddDelflagToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :delflag, :boolean
  end
end
