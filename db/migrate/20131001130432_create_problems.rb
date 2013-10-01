class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :body
      t.integer :time_limit
      t.integer :memory_limit

      t.timestamps
    end
  end
end
