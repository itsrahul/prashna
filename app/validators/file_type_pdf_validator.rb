class FileTypePdfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\.(pdf)\z/i
      record.errors[attribute] << (options[:message] || "must be a PDF.")
    end
  end
end