require 'spec_helper'

describe Idid::Configuration do
  subject { Idid::Configuration.new('project' => project, 'email' => email, 'delivery' => delivery) }
  let(:email) { 'foo@example.com' }
  let(:project) { 'foobar' }
  let(:delivery) { {:method => :sendmail} }

  its('project') { should eq project }
  its('email')   { should eq email   }

  context "when any of the options are missing" do
    before do
      Idid::Configuration.any_instance.stub(:read_config) { nil }
    end

    it 'raises ArgumentError if no email option is passed' do
      expect { Idid::Configuration.new('project' => project, 'delivery' => delivery) }.
        to raise_error(ArgumentError, /email/)
    end

    it 'raises ArgumentError if no project option is passed' do
      expect { Idid::Configuration.new('email' => email, 'delivery' => delivery) }.
        to raise_error(ArgumentError, /project/)
    end

    it 'raises ArgumentError if no delivery option is passed' do
      expect { Idid::Configuration.new('email' => email, 'project' => project) }.
        to raise_error(ArgumentError, /delivery/)
    end
  end
end
