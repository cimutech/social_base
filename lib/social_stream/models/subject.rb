module SocialStream
  module Models
    # {Subject Subjects} are subtypes of {Actor Actors}. {SocialStream Social Stream} provides two
    # {Subject Subjects}, {User} and {Group}
    #
    # Each {Subject} must defined in +config/initializers/social_stream.rb+ in order to be
    # included in the application.
    #
    # = Scopes
    # There are several scopes available for subjects
    #
    # alphabetic:: sort subjects by name
    # name_search:: simple search by name
    # distinct_initials:: get only the first letter of the name
    # followed:: sort by most following incoming {Tie ties}
    # liked:: sort by most likes
    #
    module Subject
      extend ActiveSupport::Concern

      included do
        subtype_of :actor,
                   :build => { :subject_type => to_s }

        has_one :activity_object, :through => :actor

        acts_as_url :name, :url_attribute => :slug

        validates_presence_of :name

        # accepts_nested_attributes_for :profile

        scope :tagged_with, lambda { |param|
          if param.present?
            joins(:actor => :activity_object).merge(ActivityObject.tagged_with(param))
          end
        }

        scope :followed, lambda {
          joins(:actor).
            merge(Actor.followed)
        }

        scope :liked, lambda {
          joins(:actor => :activity_object).
            order('activity_objects.like_count DESC')
        }

        scope :most, lambda { |m|
          types = %w( followed liked )

          if types.include?(m)
            __send__ m
          end
        }
      end

      def to_param
        slug
      end

      #Returning the email address of the model if an email should be sent for this object (Message or Notification).
      #If the actor is a Group and has no email address, an array with the email of the highest rank members will be
      #returned isntead.
      #
      #If no mail has to be sent, return nil.
      def mailboxer_email(object)
        #If actor has enabled the emails and has email
        return "#{name} <#{email}>" if not self.is_a?(Group) and self.email.present?
        #If actor is a Group, has enabled emails but no mail we return the highest_rank ones.
        if (group = self.subject).is_a? Group
          emails = Array.new
          group.relation_notifys.each do |relation|
            receivers = group.contact_actors(:direction => :sent, :relations => relation)
            receivers.each do |receiver|
              next unless Actor.normalize(receiver).subject_type.eql?("User")

              receiver_emails = receiver.subject.mailboxer_email(object)
              case receiver_emails
              when String
                emails << receiver_emails
              when Array
                receiver_emails.each do |receiver_email|
                  emails << receiver_email
                end
              end
            end
          end
        return emails
        end
      end
    end
  end
end
