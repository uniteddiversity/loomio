class InvitationService

  def self.email_invitations(recipient_emails: nil,
                             message: nil,
                             invitable: nil,
                             inviter: nil)
    recipient_emails.each do |recipient_email|
      if invitable.kind_of?(Group)
        invitation = Invitation.to_join_group(recipient_email: recipient_email,
                                   invitable: invitable,
                                   inviter: inviter)
        InvitePeopleMailer.delay.to_join_group(invitation, inviter, message)
      elsif invitable.kind_of?(Discussion)
        invitation = Invitation.to_join_discussion(recipient_email: recipient_email,
                                        invitable: invitable,
                                        inviter: inviter)
        InvitePeopleMailer.delay.to_join_discussion(invitation, inviter, message)
      end
    end
  end
end