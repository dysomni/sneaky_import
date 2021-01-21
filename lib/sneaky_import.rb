require "sneaky_import/version"
require 'active_support/inflector'

module SneakyImport

  def sneaky_import(*args)
    result = Rails.logger.silence { import(*args) }
    sneaky_log(result)
  end

  def sneaky_import!(*args)
    result = Rails.logger.silence { import!(*args) }
    sneaky_log(result)
  end

  def sneaky_log(result)
    sneaky_log_result result
    sneaky_log_error_messages result
    result
  end

  def sneaky_log_result(result)
    class_name       = to_s.pluralize.colorize(:magenta)
    imported_message = "#{result.ids.length} imported".colorize(:light_green)
    failed_message   = "#{result.failed_instances.length} failed".colorize(:red)
    Rails.logger.info "#{class_name} >>> #{imported_message} / #{failed_message} <<<"
  end

  def sneaky_log_error_messages(result)
    return if results.failed_instances.length.zero?

    messages = result.failed_instances.map{|i| i&.errors&.full_messages}
                     .compact.flatten.uniq
    messages.each{|m| Rails.logger.error m.to_s.colorize(:red)}
  end

  def sneaky_to_a
    result = Rails.logger.silence { all.to_a }
    Rails.logger.info "Selected #{result.count} #{to_s.pluralize(result.count)}".colorize(:light_blue)
    result
  end

end

ActiveRecord::Base.send :extend, SneakyImport
