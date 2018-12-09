# Hubspot Single Send API SDK for use with Ruby on Rails

Wraps the HubSpot Single Send API https://developers.hubspot.com/docs/methods/email/transactional_email.

Documentation for the Single Send API can be found here: https://developers.hubspot.com/docs/methods/email/transactional_email/single-send-overview

## Setup

    gem install hubspot-mailer

Or with bundler,

```ruby
gem "hubspot-mailer"
```

## Authentication with an API key

Before using the library, you must initialize it with your HubSpot API key. If you're using Rails, put this code in an initializer:

```ruby
Hubspot.configure(hapikey: "YOUR_API_KEY")
```

If you have a HubSpot account, you can get your api key by logging in and visiting this url: https://app.hubspot.com/keys/get

## Usage

The usage is the same as for ActionMailer with that difference there is no way to add attachments and a set of additional params.

```ruby
class ApplicationMailer < Hubspot::Mailer
  default from: "info@example.com"

  def test_mail
    mail(
      to:                 "john.doe@example.com",
      subject:            "Test Email",
      email_id:           123,
      send_id:            SecureRandom.hex(8)
      contact_properties: { first_name: "John", last_name: "Doe" },
      custom_properties:  { property: "Value" }
    )
  end
end
```

## Properties

```
email_id – The content ID for the transactional email, which can be found in Email Tool UI.
send_id – The ID of a particular send. No more than one email with a given sendId will be send per portal, so including a sendId is a good way to prevent duplicate email sends.
contact_properties – A JSON array of contact property values. Each property will get set on the contact record and will be visible in the template under {{ contact.NAME }}.
custom_properties – A JSON array of property values. Each property will be visible in the template under {{ custom.NAME }}.
```
