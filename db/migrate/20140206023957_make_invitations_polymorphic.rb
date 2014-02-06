class MakeInvitationsPolymorphic < ActiveRecord::Migration
  def up
    change_table :invitations do |t|
      t.references :invitable, polymorphic: true
    end

    Invitation.reset_column_information
    ActiveRecord::Base.record_timestamps = false
    begin
      puts "Updating #{Invitation.last.id} Invitation records to polymorphic"
      Invitation.find_each do |i|
        p i.id if i.id % 100 == 0

        i.invitable_type = 'group'
        i.invitable_id = i.group_id
        i.save
      end
    ensure
      ActiveRecord::Base.record_timestamps = true
    end

    # change_column_null(:invitations, :invitable_id, false)
    # change_column_null(:invitations, :invitable_type, false)

    remove_column :invitations, :group_id
  end

  def down
    add_column :invitations, :group_id

    Invitation.reset_column_information
    ActiveRecord::Base.record_timestamps = false
    begin
      puts "Reverting #{Invitation.last.id} Invitation records to be non-polymorphic"
      Invitation.find_each do |i|
        p i.id if i.id % 100 == 0

        i.group_id = i.invitable_id
        i.save
      end
    ensure
      ActiveRecord::Base.record_timestamps = true
    end

    change_column_null(:invitations, :group_id, false)

    # remove_column :invitations, :invitable_id
    # remove_column :invitations, :invitable_type
  end
end
