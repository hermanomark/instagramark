class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.belongs_to :user
      t.belongs_to :following, class: 'User'

      t.timestamps
    end
  end
end
