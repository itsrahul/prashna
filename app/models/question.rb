class Question < ApplicationRecord
  enum status: { draft: 0, published: 1 }
  
  has_one_attached :file

  belongs_to :user
  has_and_belongs_to_many :topics

  validates :title, uniqueness: { case_sensitive: false }, presence: true
  validates :content, presence: true
  validates :questions_topic, length: { minimum: 1 }
  validates :file_name, file_type_pdf: true, if: Proc.new {|q| q.file.attached? }

  after_validation :set_slug, on: [:create, :update]
  before_destroy :ensure_not_published

  scope :search_by_title, ->(val) {
    published.where("title like ?", "%#{val}%").order(updated_at: :desc)
  }

  def to_param
    "#{id}-#{slug}"
  end
  
  private def set_slug
    self.slug = title.to_s.parameterize
  end

  private def ensure_not_published
    # change name and condition to until answered/commment/votes
    if published?
      errors.add(:base, 'Question published, cannot be deleted now.')
      throw :abort
    end
  end

  private def file_name
    file.attachment.blob.filename.to_s
  end

  private def questions_topic
    topics.length
  end
end
