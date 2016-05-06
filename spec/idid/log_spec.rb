require 'spec_helper'

describe Idid::Log do

  before do
    Idid::Log.any_instance.stub(:tasks){ tasks }
  end

  subject { log }
  let(:log) { Idid::Log.new log_date }
  let(:log_date) { Date.new 2013, 1, 1}
  let(:tasks) { [Idid::Task.new('Foo')] }

  its(:log_date) { should eq log_date }
  its(:tasks) { should eq tasks }

  describe "#add_task" do
    before { log.add_task task }
    subject { log.tasks }
    let(:task) { Idid::Task.new 'Bar' }

    its(:size) { should eq 2 }
    its(:last) { should eq task }
  end

  describe "#list" do
    subject { log.list }

    context "logged items exist" do
      it { should match /Log for 1 January 2013/ }
      it { should match /\* Foo/ }
    end

    context "no logged items" do
      let(:tasks) { [] }
      it { should match /Could not find any activity for 1 January 2013/ }
    end
  end

  describe "#to_hash" do
    subject { log.to_hash }
    it { should eq({'2013-01-01' => ['Foo']}) }
  end

  describe "#human_date" do
    subject { log.human_date }

    context "date with single digit day" do
      let(:log_date) { Date.new 2013, 1, 1}
      it { should eq '1 January 2013' }
    end

    context "date with double digit day" do
      let(:log_date) { Date.new 2013, 1, 10}
      it { should eq '10 January 2013' }
    end
  end

  describe "#formatted_date" do
    subject { log.formatted_date }
    let(:log_date) { Date.new 2013, 1, 13 }
    it { should eq '2013-01-13' }
  end

  describe "#formatted_tasks" do
    subject { log.formatted_tasks }
    it { should match /\* Foo/ }
  end

end