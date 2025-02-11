class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  acts_as_taggable_on :tags

  REWARD_RATES = ["高還元率（1%以上）", "中還元率（0.5%〜1%）", "低還元率（0.5%未満）"]

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :reward_rate, inclusion: { in: REWARD_RATES, allow_blank: true }
  validates :rate, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end