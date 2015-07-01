class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.string :name
      t.string :command
      t.string :modifyingUL
      t.string :enabled
      t.timestamps null: false
    end
  end
end
