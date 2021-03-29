ActionMailer::Base.smtp_settings = {
    :user_name => ENV["SENDINBLUE_EMAIL"],
    :password => ENV["SENDINBLUE_PASSWORD"],
    :domain => ENV["DOMAIN"],
    :address => ENV["SENDINBLUE_SMTP"],
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}
