module Validations
  include ActiveSupport::Concern

  def words_in_content
    content.scan(/\w+/)
  end
  
end
