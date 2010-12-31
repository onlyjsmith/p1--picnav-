class AddPicId < ActiveRecord::Migration
  def self.up
    add_column :links, :pic_id, :integer
  end

  def self.down
    remove_column :links, :pic_id
  end
end
