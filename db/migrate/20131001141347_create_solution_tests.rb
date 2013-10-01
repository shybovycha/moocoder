class CreateSolutionTests < ActiveRecord::Migration
  def change
    create_table :solution_tests do |t|
      t.text :got
      t.text :expected
      t.integer :problem_id

      t.timestamps
    end
  end
end
