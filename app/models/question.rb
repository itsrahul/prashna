class Question < ApplicationRecord
  include SetTopic
  include QuestionPublished

  include BasicPresenter::Concern
  enum status: { draft: 0, published: 1 }
  enum abuse_status: { unabused: 0, abused: 1 }

  extend ActiveModel::Callbacks
  define_model_callbacks :publish, :only => [:before, :after]

  validates :title, uniqueness: { case_sensitive: false }, presence: true
  validates :content, presence: true
  validates :questions_topic, length: { minimum: 1 }
  validates :doc, file_type_pdf: true, if: Proc.new {|q| q.doc.attached? }


  belongs_to :user
  has_one_attached :doc
  has_and_belongs_to_many :topics
  has_many :answers, dependent: :restrict_with_error
  has_many :credit_transactions, as: :creditable
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :abuse_reports, as: :abusable

  default_scope { unabused }

  scope :search_by_title, ->(val) {
    published.where("title like ?", "%#{val}%")
  }

  scope :since, ->(time) {
    published.where("updated_at > ?", time )
  }

  after_validation :set_slug, on: [:create, :update]
  before_create  :ensure_credit_balance
  before_update  :ensure_not_published, :ensure_not_abused
  before_destroy :ensure_not_published, :ensure_not_abused
  after_commit   :actions_if_abused
  after_publish  :notify_other_users_and_charge_user, :set_published_at

  @delegation_methods = [:markdown_content, :published_ago]
  delegate *@delegation_methods, to: :presenter

  def publish
    run_callbacks :publish
  end

  def notify_other_users_and_charge_user
    if not credit_transactions.exists?
      notify_users_except(user)
      charge_credits(user)
    end
  end

  def set_published_at
    update_columns(published_at: Time.current)
  end

  def to_param
    "#{id}-#{slug}"
  end

  private def set_slug
    self.slug = title.to_s.parameterize
  end

  private def ensure_not_published
    if status_was == "published"
      errors.add(:base, 'Question published, cannot be changed now.')
      throw :abort
    end
  end

  private def ensure_credit_balance
    if not user.has_sufficient_credits_to_post_question?
      errors.add(:base, 'Question cannot be published due to low balance.')
      throw :abort
    end
  end

  private def actions_if_abused
    if abused?
      update_columns(status: 0)
    end
  end

  private def ensure_not_abused
    if abused?
      errors.add(:base, 'Question cannot be published as it has reported too many times.')
      throw :abort
    end
  end

  private def questions_topic
    topics.length
  end
end
