class InvitationService

  def self.invite_to_start_group(args)
    args[:to_be_admin] = true
    args[:intent] = 'start_group'
    Invitation.create(args)
  end

  def self.invite_to_join_group(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    Invitation.create(args)
  end

  def self.invite_to_join_discussion(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_discussion'
    Invitation.create(args)
  end

  def self.invite_after_membership_request_approval(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    Invitation.create(args)
  end

  def self.email_invitations(recipient_emails: nil,
                             message: nil,
                             invitable: nil,
                             inviter: nil)
    recipient_emails.each do |recipient_email|
      if invitable.kind_of?(Group)
        invitation = invite_to_join_group(recipient_email: recipient_email,
                                              invitable: invitable,
                                              inviter: inviter)
        InvitePeopleMailer.delay.to_join_group(invitation, inviter, message)
      elsif invitable.kind_of?(Discussion)
        invitation = invite_to_join_discussion(recipient_email: recipient_email,
                                        invitable: invitable,
                                        inviter: inviter)
        InvitePeopleMailer.delay.to_join_discussion(invitation, inviter, message)
      end
    end
  end
end
