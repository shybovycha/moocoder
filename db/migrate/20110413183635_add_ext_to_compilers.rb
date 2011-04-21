class AddExtToCompilers < ActiveRecord::Migration
  def self.up
    add_column :compilers, :ext, :string
  end

  def self.down
    remove_column :compilers, :ext
  end
end
