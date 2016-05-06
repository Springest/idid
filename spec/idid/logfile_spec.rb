require 'spec_helper'

describe Idid::Logfile do

  before do
    Idid::Logfile.any_instance.stub(:json_file) { test_json }
  end

  let(:logfile) { Idid::Logfile.new }
  let(:log_hash) { {'2013-01-01' => ['Foo'], '2013-01-02' => ['Bar']} }

  describe "#logs" do
    subject { logfile.logs }
    its(:size) { should eq 2 }
  end

  describe "#to_hash" do
    subject { logfile.to_hash }
    it { should eq log_hash }
  end

  describe "#to_json" do
    subject { logfile.to_json }
    it { should eq log_hash.to_json }
  end

end

