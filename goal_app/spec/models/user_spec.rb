# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) {
    User.create!(
      username: 'larry',
      password: 'password'
      # password_digest: '83y4uhsd87d743hdusytfaiey',
      # session_token: 'dhsa3984dha'
    )
  }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:session_token) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:session_token) }

  # it { should validate_length_of(:password).is_at_least(6)}

  describe "#reset_session_token" do
    it "resets a user's session token" do
      user.save!
      popcorn = User.find_by(username: 'larry')
      old_token = popcorn.session_token
      popcorn.reset_session_token!
      expect(popcorn.session_token).to_not be(old_token)
    end
  end

  describe "#ensure_session_token" do
    context "with session token already set" do
      it "return the current session token" do
        original = user.session_token
        user.ensure_session_token
        expect(user.session_token).to eq(original)
      end
    end

    context "no session token set" do
      it "should set a session token" do
        user.session_token = nil
        # original = new_user.session_token
        user.ensure_session_token
        expect(user.session_token).to_not eq(nil)
      end
    end
  end

  describe "#password=" do
    it "sets an instance variable for password" do
      user.password = 'password'
      expect(user.password).to eq('password')
    end

    it "sets a password digest by running password through BCrypt" do
      user.password = 'password'
      expect(user.password_digest).to eq(BCrypt::Password.new(user.password_digest))
    end
  end

  describe "#is_password?" do
    it "should check if the user's password digest matches the encrypted version of the entered password" do
      user.password = "password"
      expect(user.is_password?('password')).to eq(true)
    end
  end

  describe "::find_by_credentials" do
    it "checks if the user exists in the database" do
      new_user = User.new(username: 'bob', password: 'bob1234') 
      expect(User.find_by_credentials('bob', 'bob1234')).to eq(nil)
    end

    # it "calls #is_password? if user exists in the database" do
      
    #   user.password = "password"
    #   user.save!
    #   found = User.find_by(username: 'larry')
    #   expect(found).to receive(:is_password?).with('password')
    #   User.find_by_credentials('larry', 'password')
    # end

    it "returns the user if #is_password? returns true" do
      user.password = "password"
      user.save!
      expect(User.find_by_credentials('larry', 'password')).to eq(user) 
    end
  end

end
