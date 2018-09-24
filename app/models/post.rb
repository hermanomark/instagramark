class Post < ApplicationRecord
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" } # default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :image_file_name, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 200 }
end