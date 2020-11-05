class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value =~ /[a-zA-Z]{1,}/i
      record.errors[attribute] << (options[:message] || "should have atleast 1 alphabet")
    end
    if not value =~ /[0-9]{1,}/i
      record.errors[attribute] << (options[:message] || "should have atleast 1 digit")
    end
  end
end
