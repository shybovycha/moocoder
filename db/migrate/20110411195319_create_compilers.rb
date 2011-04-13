class CreateCompilers < ActiveRecord::Migration
  def self.up
    create_table :compilers do |t|
      t.string :title
      t.text :cmd_line

      t.timestamps
    end
  end

  def self.down
    drop_table :compilers
  end
end
