class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /[a-zA-Z]{1,}\z/i
      record.errors[attribute] << (options[:message] || "should have atleast 1 alphabet")
    end
    unless value =~ /[0-9]{1,}\z/i
      record.errors[attribute] << (options[:message] || "should have atleast 1 digit")
    end
  end
end