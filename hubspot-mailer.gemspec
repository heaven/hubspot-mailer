Gem::Specification.new do |s|
  s.name        = "hubspot-mailer".freeze
  s.version     = "0.0.4"
  s.licenses    = ['MIT']
  s.date        = "2022-10-19".freeze
  s.description = "Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails. Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails. Create beautiful transactional emails right within HubSpot using the email editor with all the benefits of smart content, personalization and templates - just like regular HubSpot emails.".freeze
  s.summary     = "HubSpot Single Send API SDK for use with Ruby on Rails".freeze
  s.authors     = ["heaven".freeze]
  s.email       = ["hello@codeart.us".freeze]
  s.homepage    = "https://github.com/heaven/hubspot-mailer".freeze
  s.files       = [
    "lib/hubspot-mailer.rb",
    "lib/hubspot/mailer.rb",
    "lib/hubspot/mailer/delivery.rb",
    "lib/hubspot/mailer/exceptions.rb",
    "lib/hubspot/mailer/hubspot_preview_interceptor.rb",
    "lib/hubspot/mailer/message.rb",
  ]
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency(%q<httparty>.freeze, ["~> 0.20.0"])
      s.add_runtime_dependency(%q<actionmailer>.freeze, ["< 6.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<httparty>.freeze, ["~> 0.20.0"])
      s.add_dependency(%q<actionmailer>.freeze, ["< 6.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<httparty>.freeze, ["~> 0.20.0"])
    s.add_dependency(%q<actionmailer>.freeze, ["~> 5.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
  end
end
