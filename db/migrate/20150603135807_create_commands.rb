class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.string :execUserLevel
      t.string :response
      t.string :script
      t.string :enabled
      t.integer :minArgs
      t.string :responseModifyingUL
      t.string :userLevelModifyingUL
      t.string :nameModifyingUL
      t.timestamps null: false
    end
  end
end
