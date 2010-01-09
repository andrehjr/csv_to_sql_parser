require File.dirname(__FILE__) + '/../spec_helper'
 
describe Column do
  
  it "should add a column name" do
    c = Column.new "id"
    c.name.should == "id"
  end
  
  it "should be able to pass a block" do
    c = Column.new "id" do |value|
      value + "i"
    end
    c.callback.should_not be_nil
  end
  
  it "should evaluate values" do
    c = Column.new "id" do |value|
      value + "i"
    end
    c.evaluate("1").should == "1i"
  end
end