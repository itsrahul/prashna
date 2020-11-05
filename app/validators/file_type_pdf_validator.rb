class FileTypePdfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.attachment.content_type =~ /(pdf)\z/i
      record.errors[attribute] << (options[:message] || "must be a PDF.")
    end
  end
end