class CreateCompilers < ActiveRecord::Migration
  def change
    create_table :compilers do |t|
      t.string :title
      t.text :run_command

      t.timestamps
    end
  end
end
