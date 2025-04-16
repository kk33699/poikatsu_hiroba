class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  acts_as_taggable_on :tags

  REWARD_RATES = ["高還元率（1%以上）", "中還元率（0.5%〜1%未満）", "低還元率（0.5%未満）", "その他"]

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :reward_rate, presence: true
  validates :rate, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end