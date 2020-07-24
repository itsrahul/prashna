class AbuseReport < ApplicationRecord
  validates :reason, presence: true
  validates :words_in_reason, length: { minimum: 5 }, allow_blank: true

  belongs_to :user
  belongs_to :abusable, polymorphic: true

  after_commit :check_for_abuse_count

  def words_in_content
    content.scan(/\w+/)
  end

  def check_for_abuse_count
    if abusable.abuse_reports.count >= ENV['reports_count_for_removal']
      abusable.abused!
    end
  end
end
