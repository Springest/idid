require 'spec_helper'

describe Idid::Configuration do
  subject { configuration }

  let(:configuration) { Idid::Configuration.new('team' => team, 'email' => email, 'delivery' => delivery, 'account_type' => account_type) }
  let(:email) { 'foo@example.com' }
  let(:team) { 'foobar' }
  let(:delivery) { {:method => :sendmail} }
  let(:account_type) { 'team' }

  its('team') { should eq team }
  its('email') { should eq email }
  its('account_type') { should eq account_type }

  context "when any of the options are missing" do
    before do
      Idid::Configuration.any_instance.stub(:read_config) { nil }
    end
    let(:account_type) { 'personal' }

    it 'raises ArgumentError if no team option is passed while on a team account' do
      expect { Idid::Configuration.new('email' => email, 'delivery' => delivery, 'account_type' => 'team') }.
        to raise_error(ArgumentError, /team/)
    end

    it 'doesnt raises ArgumentError if no team option is passed while on a personal account' do
      expect { Idid::Configuration.new('email' => email, 'delivery' => delivery, 'account_type' => 'personal') }.
        to_not raise_error
    end

    it 'raises ArgumentError if no email option is passed' do
      expect { Idid::Configuration.new('team' => team, 'delivery' => delivery, 'account_type' => account_type) }.
        to raise_error(ArgumentError, /email/)
    end

    it 'raises ArgumentError if no delivery option is passed' do
      expect { Idid::Configuration.new('email' => email, 'team' => team, 'account_type' => account_type) }.
        to raise_error(ArgumentError, /delivery/)
    end

    it 'raises ArgumentError if no account type is passed' do
      expect { Idid::Configuration.new('email' => email, 'team' => team, 'delivery' => delivery) }.
        to raise_error(ArgumentError, /account type/)
    end
  end

  describe "#idonethis_email" do
    subject { configuration.idonethis_email }

    context "team account" do
      let(:account_type) { 'team' }
      let(:team) { 'foobar' }
      it { should eq 'foobar@team.idonethis.com' }
    end

    context "personal account" do
      let(:account_type) { 'personal' }
      it { should eq 'today@idonethis.com' }
    end
  end

  describe "#personal_account?" do
    subject { configuration.personal_account? }

    let(:account_type) { 'personal' }
    it { should be_true }
  end

  describe "#team_account?" do
    subject { configuration.team_account? }

    let(:account_type) { 'team' }
    it { should be_true }
  end

end
