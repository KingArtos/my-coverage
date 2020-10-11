class CreatePartners < ActiveRecord::Migration[6.0]
  def change
    create_table(:partners, id: :bigint) do |t|
    	t.string :trading_name, null: false
      t.string :owner_name, null: false
      t.string :document, null: false, unique: true
      t.multi_polygon :coverage_area, null: false, srid: 4326
      t.geography "address", limit: {srid: 4326, type: "point", geographic: true}, null: false

      t.timestamps
    end
  end
end
