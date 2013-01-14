require 'spec_helper'

describe Idid::Delivery do

  subject { delivery }

  let(:delivery) { Idid::Delivery.new config }
  let(:config) do
    Idid::Configuration.new(
      'team' => 'foo',
      'email' => 'john@example.com',
      'delivery' => { 'method' => :test },
      'account_type' => 'team'
    )
  end

  its('config') { should eq config }

  describe "#email" do
    subject { delivery.email 'Tested Idid::Deliver.email' }
    its(:to) { should eq ['foo@team.idonethis.com'] }
    its(:from) { should eq ['john@example.com'] }
    its(:body) { should eq 'Tested Idid::Deliver.email' }
  end

end