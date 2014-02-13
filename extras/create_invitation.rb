class CreateInvitation
  def self.to_start_group(args)
    args[:to_be_admin] = true
    args[:intent] = 'start_group'
    Invitation.create(args)
  end

  def self.to_join_group(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    Invitation.create(args)
  end

  def self.to_join_discussion(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_discussion'
    Invitation.create(args)
  end

  def self.after_membership_request_approval(args)
    args[:to_be_admin] = false
    args[:intent] = 'join_group'
    Invitation.create(args)
  end

  def self.to_group_and_email_people(recipient_emails: nil,
                                    message: nil,
                                    invitable: nil,
                                    inviter: nil)
    recipient_emails.each do |recipient_email|
      invitation = to_join_group(recipient_email: recipient_email,
                                 invitable: invitable,
                                 inviter: inviter)
      InvitePeopleMailer.delay.to_join_group(invitation, inviter, message)
    end
    recipient_emails.size
  end

  def self.to_discussion_and_email_people(recipient_emails: nil,
                                    message: nil,
                                    invitable: nil,
                                    inviter: nil)
    recipient_emails.each do |recipient_email|
      invitation = to_join_discussion(recipient_email: recipient_email,
                                 invitable: invitable,
                                 inviter: inviter)
      InvitePeopleMailer.delay.to_join_discussion(invitation, inviter, message)
    end
    recipient_emails.size
  end
end
