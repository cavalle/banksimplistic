# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fohjinrb_session',
  :secret      => '7dde497e4c391d29666e0869f358943b0fa133d20c606bf359ba1165342cb4492bc8fe7c6a2aa86955e4a1b6a00858c1e515e5adc20abc33f5f0bac91c057eec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
