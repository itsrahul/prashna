module MarkAbused
  include ActiveSupport::Concern

  def mark_abused!
      update_columns(abuse_status: 'abused')
      if self.is_a? Question
        update_columns(status: 'draft')
      elsif self.is_a? Answer
        if not (credit_sum = credit_transactions.sum(:value)).zero?
          credit_transactions.others.create(user: user, value: -1 * credit_sum.abs, reason: "abuse reported, bonus reverted")
        end
      end
  end
end
