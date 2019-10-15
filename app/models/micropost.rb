class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content picture).freeze

  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: Settings.content}
  validate :picture_size

  scope :feed , ->(id) {where user_id: id}
  
  private

  def picture_size
    return unless picture.size > Settings.picture_size.megabytes
    errors.add :picture, t(".less")
  end
end
