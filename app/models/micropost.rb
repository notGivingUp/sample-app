class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content_leng_max}
  validate :picture_size

  scope :order_desc, ->{order created_at: :desc}
  feed = lambda do |id|
    where "user_id IN (SELECT followed_id FROM relationships
      WHERE follower_id = #{id}) OR user_id = #{id}"
  end
  scope :feeds, feed
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.picture.max_size.megabytes
    errors.add :picture, t("picture.add_error")
  end
end
