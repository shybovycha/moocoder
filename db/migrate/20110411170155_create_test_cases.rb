class CreateTestCases < ActiveRecord::Migration
  def self.up
    create_table :test_cases do |t|
      t.integer :problem_id
      t.text :given
      t.text :expected

      t.timestamps
    end
  end

  def self.down
    drop_table :test_cases
  end
end
