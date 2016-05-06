require 'spec_helper'

describe Idid::Task do
  subject { task }

  let(:task) { Idid::Task.new contents }
  let(:contents) { 'Bar' }

  its(:contents) { should eq contents }

  describe "#to_s" do
    subject { task.to_s }
    it { should eq 'Bar' }
  end

  describe "#to_item" do
    subject { task.to_item }
    it { should eq '* Bar'}
  end
end