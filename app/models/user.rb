require 'devise/orm/active_record'

# Every social network must have users, and a social network builder couldn't be the exception.
#
# Social Stream uses the awesome gem {Devise https://github.com/plataformatec/devise}
# for managing authentication
#
# Almost all the logic of the interaction between {User} and the rest of classes in Social Stream
# is done through {Actor}. The glue between {User} and {Actor} is in {SocialStream::Models::Subject}
#
class User < ActiveRecord::Base
  include SocialStream::Models::Subject

  devise :database_authenticatable, :token_authenticatable, :rememberable, :trackable, :timeoutable

  has_many :user_authored_objects,
           :class_name => "ActivityObject",
           :foreign_key => :user_author_id

  has_one  :avatar,
           :as => :avatarable,
           :validate => true,
           :autosave => true,
           :dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :language, :remember_me, :profile_attributes

  validates_presence_of :email

  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true

  validate :email_must_be_uniq

  with_options :if => :password_required? do |v|
    v.validates_presence_of     :password
    v.validates_confirmation_of :password
    v.validates_length_of       :password, :within => Devise.password_length, :allow_blank => true
  end

  scope :letter, lambda { |param|
    if param.present?
      where('actors.name LIKE ?', "#{ param }%")
    end
  }

  scope :name_search, lambda { |param|
    if param.present?
      where('actors.name LIKE ?', "%#{ param }%")
    end
  }

  def recent_groups
    contact_subjects(:type => :group, :direction => :sent) do |q|
      q.select("contacts.created_at").
        merge(Contact.recent)
    end
  end

  # Subjects this user can acts as
  def represented
    candidates = contact_actors(:direction => :sent).map(&:id)

    contact_subjects(:direction => :received) do |q|
      q.joins(:sent_ties => { :relation => :permissions }).
        merge(Permission.represent).
        where(:id => candidates)
    end
  end

  def logo
    avatar!.logo
  end

  def avatar!
    avatar || build_avatar
  end

  protected

  # From devise
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  private

  def email_must_be_uniq
    user = User.find_by_email(email)
    if user.present? && user.id =! self.id
      errors.add(:email, "is already taken")
    end
  end

end
