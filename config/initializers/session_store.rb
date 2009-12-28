# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_my_rails_app_session',
  :secret      => 'a6a043325b0e5bb86ddee5d112870f8a5290faa81e7d8fbb9ef3570377e6451cc89e0d1c47baee237c6e2a18c3c78fdba6d0a7cfc5eed58d8b255c3c6bf62c43'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
