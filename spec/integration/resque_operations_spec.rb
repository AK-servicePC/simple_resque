require "spec_helper"
require "simple_resque"

describe "Pushing a job to Resque" do
  it "suceeds" do
    expect {
      SimpleResque.push("TransformVehicle",[5, "autobot"])
    }.to change { Resque.size(:transform_vehicle) }.from(0).to(1)

    job = Resque.pop(:transform_vehicle)
    job["class"].should == "TransformVehicle"
    job["args"].should == [5,"autobot"]
  end
end

describe "Getting queue size from Resque" do
  it "succeeds" do
    Resque.remove_queue(:buy_stuff)
    Resque.push(:buy_stuff,class: "BuyStuff", args: [])
    Resque.push(:buy_stuff,class: "BuyStuff", args: [])
    SimpleResque.size("BuyStuff").should == 2
  end
end

describe "Popping jobs from Resque" do
  it "succeeds" do
    Resque.remove_queue(:shaz)
    Resque.push(:shaz,class: "Shaz", args: %q(1 2 3))
    SimpleResque.pop("Shaz").should == { "class" => "Shaz", "args" => %q(1 2 3) }
  end
end
