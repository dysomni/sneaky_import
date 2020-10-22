require "sneaky_import/version"

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
    log_color = result.failed_instances.length == 0 ? :light_green : :red
    Rails.logger.info "#{to_s.pluralize} >>> #{result.ids.length} imported / #{result.failed_instances.length} failed <<<".colorize(log_color)
    return result
  end

  def sneaky_to_a
    result = Rails.logger.silence { all.to_a }
    Rails.logger.info "Selected #{result.count} #{to_s.pluralize(result.count)}".colorize(:light_blue)
    return result
  end

end

ActiveRecord::Base.send :extend, SneakyImport
