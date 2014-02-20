class Invitation < ActiveRecord::Base

  class InvitationCancelled < StandardError
  end

  class InvitationAlreadyUsed < StandardError
  end

  extend FriendlyId
  friendly_id :token
  belongs_to :inviter, class_name: User
  belongs_to :accepted_by, class_name: User
  belongs_to :invitable, polymorphic: true
  belongs_to :canceller, class_name: User

  validates_presence_of :invitable, :intent
  validates_inclusion_of :invitable_type, :in => ['Group', 'Discussion']
  validates_inclusion_of :intent, :in => ['start_group', 'join_group', 'join_discussion']
  before_save :ensure_token_is_present

  scope :not_cancelled,  -> { where(cancelled_at: nil) }
  scope :pending, -> { not_cancelled.where(accepted_at: nil) }

  def recipient_first_name
    recipient_name.split(' ').first
  end

  def inviter_name
    inviter.name
  end

  def group
    case invitable_type
    when 'Group'
      invitable
    when 'Discussion'
      invitable.group
    end
  end

  def invitable_name
    case invitable_type
    when 'Group'
      invitable.name
    when 'Discussion'
      invitable.title
    end
  end

  def group_request_admin_name
    if invitable == 'Group'
      invitable.group_request.admin_name
    end
  end

  def cancel!(args)
    self.canceller = args[:canceller]
    self.cancelled_at = DateTime.now
    self.save!
  end

  def cancelled?
    cancelled_at.present?
  end

  def accepted?
    accepted_by.present?
  end

  def to_start_group?
    intent == 'start_group'
  end

  def to_join_group?
    intent == 'join_group'
  end

  def to_join_discussion?
    intent == 'join_discussion'
  end

  def invitations_remaining
    max_size - memberships_count - pending_invitations.count
  end

  def self.to_start_group(args)
    args[:to_be_admin] = true
    args[:intent] = 'start_group'
    create(args)
  end

  def self.to_join_group(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    create(args)
  end

  def self.to_join_discussion(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_discussion'
    create(args)
  end

  def self.after_membership_request_approval(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    Invitation.create(args)
  end

  private
  def ensure_token_is_present
    unless self.token.present?
      set_unique_token
    end
  end

  def set_unique_token
    begin
      token = (('a'..'z').to_a +
               ('A'..'Z').to_a +
               (0..9).to_a).sample(20).join
    end while self.class.where(:token => token).exists?
    self.token = token
  end

end
