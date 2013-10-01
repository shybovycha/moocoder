class CreateBuildSteps < ActiveRecord::Migration
  def change
    create_table :build_steps do |t|
      t.text :command
      t.integer :compiler_id

      t.timestamps
    end
  end
end
