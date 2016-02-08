class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, unique:true
  	# unique in index column as well
  end
end
