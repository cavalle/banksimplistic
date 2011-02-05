class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :aggregate_uid
      t.text :data

      t.timestamps
    end

    add_index :events, :aggregate_uid
  end

  def self.down
    remove_index :events, :aggregate_uid
    drop_table :events
  end
end
