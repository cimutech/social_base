module SocialStream
  # {SocialStream::Base} provides with the minimal functionality for a web-based
  # social network: {User users }, {Group groups } and the {Tie ties } between them,
  # as well as basic activities: {Post posts } and {Comment comments}
  module Base
    class Engine < ::Rails::Engine #:nodoc:
      config.app_generators.authentication :devise
      config.app_generators.messages :mailboxer
      config.app_generators.taggings :acts_as_taggable_on

      initializer "social_base.inflections" do
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.singular /^([Tt]ie)s$/, '\1'
        end
      end

      initializer "social_base.mime_types" do
        Mime::Type.register 'application/xrd+xml', :xrd
      end

      initializer "social_base.model.supertypes" do
        ActiveSupport.on_load(:active_record) do
          include SocialStream::Models::Subtype::ActiveRecord
          include SocialStream::Models::Supertype::ActiveRecord
        end
      end

      initializer "social_base.model.load_single_relations" do
        SocialStream.single_relations.each{ |r| "Relation::#{ r.to_s.classify }".constantize }
      end

      initializer "social_base.model.register_activity_streams" do
        SocialStream::ActivityStreams.register :person, :user
        SocialStream::ActivityStreams.register :group
        SocialStream::ActivityStreams.register :note,   :post
      end

      # initializer "social_stream-base.avatars_for_rails" do
      #   AvatarsForRails.setup do |config|
      #     config.avatarable_model = :actor
      #     config.current_avatarable_object = :current_actor
      #     config.avatarable_filters = [:authenticate_user!]
      #     config.avatarable_styles = { :representation => "20x20>",
      #                                  :contact        => "30x30>",
      #                                  :actor          => '35x35>',
      #                                  :profile        => '119x119'}
      #   end
      # end

      initializer "social_base.mailboxer", :before => :load_config_initializers do
        Mailboxer.setup do |config|
          config.email_method = :subject_mailboxer_email
        end
      end

      config.to_prepare do
        ApplicationController.rescue_handlers += [["CanCan::AccessDenied", :rescue_from_access_denied]]
      end
    end
  end
end
