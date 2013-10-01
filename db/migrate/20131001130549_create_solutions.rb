class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :body
      t.string :status
      t.integer :problem_id
      t.integer :user_id
      t.integer :compiler_id

      t.timestamps
    end
  end
end
