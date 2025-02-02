class AddRewardRateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :reward_rate, :string
  end
end
