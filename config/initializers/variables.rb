 config = Rails.application.config_for(:application)
 config.keys.each{|k| ENV[k] = config[k]}
