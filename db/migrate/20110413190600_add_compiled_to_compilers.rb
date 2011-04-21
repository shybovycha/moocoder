class AddCompiledToCompilers < ActiveRecord::Migration
  def self.up
    add_column :compilers, :compiled, :boolean
  end

  def self.down
    remove_column :compilers, :compiled
  end
end
