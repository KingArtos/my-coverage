class AddIndexes < ActiveRecord::Migration[6.0]
  def change
  	change_table :partners do |t|
      t.index :coverage_area, using: :gist
  	end
  end
end
