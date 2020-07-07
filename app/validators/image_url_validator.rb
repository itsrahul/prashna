class ImageUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\.(gif|jpg|png|jpeg)\z/i
      record.errors[attribute] << (options[:message] || "must be a URL for GIF, JPEG or PNG image.")
    end
  end
end