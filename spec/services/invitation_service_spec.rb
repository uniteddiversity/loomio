require_relative '../../app/services/invitation_service'
class Invitation
  def self.to_join_group(args)
  end

  def self.to_join_discussion(args)
  end
end
class Group; end
class Discussion; end
class InvitePeopleMailer
  def self.delay
    self
  end

  def self.to_join_group(invitation, inviter, message)
  end

  def self.to_join_discussion(invitation, inviter, message)
  end
end
describe "InvitationService" do

  describe "#email_invitations" do
    context "invitable is a group" do
      let(:group) { Group.new }
      let(:user) { double(:user)  }

      it "creates an invitation to join group" do

        Invitation.should_receive :to_join_group
        InvitationService.email_invitations(recipient_emails: ["test@example.org"],
                                            message: "Hi",
                                            invitable: group,
                                            inviter: user)
      end

      it "sends an email to join a group" do

        InvitePeopleMailer.should_receive :to_join_group
        InvitationService.email_invitations(recipient_emails: ["test@example.org"],
                                            message: "Hi",
                                            invitable: group,
                                            inviter: user)
      end
    end

    context "invitable is a discussion" do
      let(:discussion) { Discussion.new}
      let(:user) { double(:user)  }

      it "creates an invitation to join discussion" do

        Invitation.should_receive :to_join_discussion
        InvitationService.email_invitations(recipient_emails: ["test@example.org"],
                                            message: "Hi",
                                            invitable: discussion,
                                            inviter: user)
      end

      it "sends an email to join a group" do

        InvitePeopleMailer.should_receive :to_join_discussion
        InvitationService.email_invitations(recipient_emails: ["test@example.org"],
                                            message: "Hi",
                                            invitable: discussion,
                                            inviter: user)
      end
    end
  end
end