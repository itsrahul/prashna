class Question < ApplicationRecord
# 1. macros
# 2. validations
# 3. associations
# 4. scopes
# 5. callbacks
  include SetTopic
  include QuestionPublished

  include BasicPresenter::Concern
  enum status: { draft: 0, published: 1 }

  validates :title, uniqueness: { case_sensitive: false }, presence: true
  validates :content, presence: true
  validates :questions_topic, length: { minimum: 1 }
  validates :doc, file_type_pdf: true, if: Proc.new {|q| q.doc.attached? }

  #FIXME_AB: user should not be able to answer on his own question


  belongs_to :user
  #FIXME_AB: add dependent option
  has_one_attached :doc
  has_and_belongs_to_many :topics
  has_many :answers
  has_many :credit_transactions, as: :creditable
  has_many :comments, as: :commentable

  scope :search_by_title, ->(val) {
    published.where("title like ?", "%#{val}%")
  }

  after_validation :set_slug, on: [:create, :update]
  before_create :ensure_credit_balance
  before_update :ensure_not_published
  before_destroy :ensure_not_published

  @delegation_methods = [:markdown_content]
  delegate *@delegation_methods, to: :presenter

  def to_param
    "#{id}-#{slug}"
  end

  private def set_slug
    self.slug = title.to_s.parameterize
  end

  private def ensure_not_published
    #FIXME_AB: this will not allow user to publish his drafted question. Use dirty objects
    if published?
      errors.add(:base, 'Question published, cannot be changed now.')
      throw :abort
    end
  end

  private def ensure_credit_balance
    if user.credits < ENV['credit_for_question_post'].to_i
      errors.add(:base, 'Question cannot be published due to low balance.')
      throw :abort
    end
  end

  private def questions_topic
    topics.length
  end
end
