require 'spec_helper'

describe Actor do

  it "should generate relations" do
    assert Factory(:user).relation_customs.present?
  end

  context 'pending contacts' do
    it 'should not include self' do
      a = Factory(:user).actor
      c = a.contact_to!(a)

      a.pending_contacts.should_not include(c)
    end
  end

  it 'should generate suggestion' do
    10.times do
      Factory(:user)
    end

    sgs = Factory(:user).suggestions(5)

    sgs.size.should be(5)

    sgs_names = sgs.map{ |s| s.receiver_subject.name }.compact

    sgs.size.should be(5)
  end

  it "should have an avatar" do
    u = Factory(:user)
    avatar = u.avatar!
    avatar.should_not be(nil)
  end

  it "should be destroyed" do
    u = Factory(:user)
    a = u.actor

    u.destroy

    Actor.find_by_id(a.id).should be_nil
  end
end
