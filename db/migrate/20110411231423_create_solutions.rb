class CreateSolutions < ActiveRecord::Migration
  def self.up
    create_table :solutions do |t|
      t.integer :problem_id
      t.integer :compiler_id
      t.text :code
      t.integer :passed
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :solutions
  end
end
