class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A\w{3,}@\w{3,}[.][a-zA-Z]{2,}\z/i
      record.errors[attribute] << (options[:message] || "is invalid")
    end
  end
end