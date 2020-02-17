# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "hubspot-mailer"
  s.version     = "0.0.2"
  s.licenses    = ["MIT"]
  s.date        = "2018-12-09"
  s.description = "Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails. Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails. Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails."
  s.summary     = "HubSpot Single Send API SDK for use with Ruby on Rails"
  s.authors     = ["heaven"]
  s.email       = ["hello@codeart.us"]
  s.homepage    = "https://github.com/heaven/hubspot-mailer"
  s.files       = [
    "lib/hubspot-mailer.rb",
    "lib/hubspot/mailer.rb",
    "lib/hubspot/mailer/delivery.rb",
    "lib/hubspot/mailer/exceptions.rb",
    "lib/hubspot/mailer/hubspot_preview_interceptor.rb",
    "lib/hubspot/mailer/message.rb"
  ]
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new("1.2.0")
      s.add_runtime_dependency("actionmailer", ["~> 5.1"])
      s.add_runtime_dependency("hubspot-ruby", ["~> 0.4"])
      s.add_development_dependency("bundler", ["~> 1.0"])
    else
      s.add_dependency("actionmailer", ["~> 5.1"])
      s.add_dependency("bundler", ["~> 1.0"])
      s.add_dependency("hubspot-ruby", ["~> 0.4"])
    end
  else
    s.add_dependency("actionmailer", ["~> 5.1"])
    s.add_dependency("bundler", ["~> 1.0"])
    s.add_dependency("hubspot-ruby", ["~> 0.4"])
  end
end
