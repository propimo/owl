class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9а-я]+\.)+[a-zа-я]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end
