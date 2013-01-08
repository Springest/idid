require 'spec_helper'

describe Idid::Task do
  subject { task }

  let(:task) { Idid::Task.new contents, logdate }
  let(:contents) { 'Bar' }
  let(:logdate) { Date.new 2013,1,1 }

  its(:contents) { should eq contents }
  its(:log) { should be_a_kind_of Hash }
  its(:logdate) { should eq Date.new(2013,1,1) }

  describe "#save" do
    before do
      Idid::Task.stub(:read_log).and_return log_file
      Idid::Task.stub(:write_log).and_return true
      task.save
    end

    subject { task.log }

    context "date has no logged items yet" do
      let(:log_file) { {"2013-02-01" => ["Foo"]} }
      it { should eq({"2013-02-01" => ["Foo"], "2013-01-01" => ["Bar"]}) }
    end

    context "date has already logged items" do
      let(:log_file) { {"2013-01-01" => ["Foo"]} }
      it { should eq({"2013-01-01" => ["Foo", "Bar"]}) }
    end
  end

  describe "#to_s" do
    subject { task.to_s }
    it { should eq contents }
  end

  describe ".list" do
    before do
      Idid::Task.stub(:read_log).and_return({"2013-01-01" => ["Foo", "Bar"]})
    end

    subject { Idid::Task.list date }

    context "logged items exist" do
      let(:date) { '2013-01-01' }
      it { should match /Log for 1 January 2013/ }
      it { should match /\* Foo/ }
      it { should match /\* Bar/ }
    end

    context "no logged items" do
      let(:date) { '2013-01-02' }
      it { should match /Could not find any activity for 2 January 2013/ }
    end
  end

end