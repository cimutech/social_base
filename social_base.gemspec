# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'lib', 'social_stream', 'base', 'version')

Gem::Specification.new do |s|
  s.name = "social_base"
  s.version = SocialStream::Base::VERSION.dup
  s.summary = "Basic features for Social Stream, the core for building social network websites"
  s.description = "Social Stream is a Ruby on Rails engine providing your application with social networking features and activity streams.\n\nThis gem packages the basic functionality, along with basic actors (user, group) and activity objects (post and comments)"
  s.authors = [ "GING - DIT - UPM",
                "CISE - ESPOL" ]
  s.homepage = "http://social-stream.dit.upm.es/"
  s.files = `git ls-files`.split("\n")

  # Runtime gem dependencies
  #
  # Do not forget to require the file at lib/social_stream/base/dependencies !
  #
  # Deep Merge support for Hashes
  s.add_runtime_dependency('deep_merge')
  # Rails
  s.add_runtime_dependency('rails', '~> 3.2.16')
  # Rails Engine Decorators
  s.add_runtime_dependency('rails_engine_decorators')
  # Activity and Relation hierarchies
  s.add_runtime_dependency('ancestry', '~> 1.2.3')
  # SQL foreign keys
  s.add_runtime_dependency('foreigner', '~> 1.1.1')
  # Authentication
  s.add_runtime_dependency('devise', '~> 2.2.3')
  # CRUD controllers
  # s.add_runtime_dependency('inherited_resources', '>= 1.3.0')
  # Slug generation
  s.add_runtime_dependency('stringex', '>= 1.5.1')
  # Avatar attachments
  # s.add_runtime_dependency('avatars_for_rails', '~> 0.2.8')
  # Messages
  s.add_runtime_dependency('mailboxer','>= 0.10.3')
  # Tagging
  s.add_runtime_dependency('acts-as-taggable-on','~> 2.2.2')
  # Sphinx search engine
  # s.add_runtime_dependency('thinking-sphinx', '~> 2.0.8')
  # Syntactically Awesome Stylesheets
  s.add_runtime_dependency('sass-rails', '>= 3.1.0')
  # Autolink text blocks
  s.add_runtime_dependency('rails_autolink', '>= 1.0.4')
  # I18n-js
  # s.add_runtime_dependency('i18n-js','>= 2.1.2')
  # Strong Parameters
  s.add_runtime_dependency('strong_parameters','>= 0.2.0')

  # cancan
  s.add_runtime_dependency('cancancan', '~> 1.7')

  # Development gem dependencies
  #
  # Testing database
  s.add_development_dependency('sqlite3-ruby')
  # Debugging
  if RUBY_VERSION < '1.9'
    s.add_development_dependency('ruby-debug')
  else
    s.add_development_dependency('debugger')
  end
  # Specs
  s.add_development_dependency('rspec-rails', '~> 2.8.1')
  # Fixtures
  s.add_development_dependency('factory_girl', '~> 1.3.2')
  # Population
  s.add_development_dependency('forgery', '~> 0.4.2')
  # Continous integration
  s.add_development_dependency('ci_reporter', '~> 1.6.4')
  # Scaffold generator
  s.add_development_dependency('nifty-generators','~> 0.4.5')
  # pry
  s.add_development_dependency('pry-rails','~> 0.3.2')
end
