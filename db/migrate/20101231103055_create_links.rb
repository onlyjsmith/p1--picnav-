class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :to_pic
      t.float :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
