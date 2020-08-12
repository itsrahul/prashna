class AbuseReport < ApplicationRecord
  validates :reason, presence: true
  validates :words_in_reason, length: { minimum: 5}, allow_blank: true

  belongs_to :user
  belongs_to :abusable, polymorphic: true

  before_create :ensure_questions_belongs_to_other_user
  after_commit :check_for_abuse_count

  def words_in_reason
    reason.scan(/\w+/)
  end

  def check_for_abuse_count
    if abusable.abuse_reports.count >= ENV['reports_count_for_removal'].to_i
      abusable.mark_abused!
    end
  end

  def question_posted_by?(given_user)
    given_user == abusable.user ? true : false
  end

  private def ensure_questions_belongs_to_other_user
    if question_posted_by?(self.user)
      errors.add(:base, 'Cannot report your own question.')
      throw :abort
    end
  end
end
