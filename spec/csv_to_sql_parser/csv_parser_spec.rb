require File.dirname(__FILE__) + '/../spec_helper'
 
describe CsvParser do
  before :each do
    @parser = CsvParser.new
    @parser.table = "person"
  end
  
  it "should be able to add columns" do
    @parser.add_column "age"
    @parser.add_column "description", :skip => true 
    @parser.add_column "id" do |value|
      value + "lol"
    end
    @parser.columns.size.should == 3
  end
  
  it "should be able load from a file" do
    @parser.add_column "age"
    @parser.add_column "name"
    @parser.from_file path("test.csv")
    @parser.parse!.should be_true
  end
  
  it "should be able to read from a string" do
    @parser.add_column "age"
    @parser.add_column "name"    
    @parser.from_string "21;andrehjr\n19;foo"
    @parser.parse!.should be_true
  end
  
  it "should not parse without data" do
    @parser.parse!.should be_false
  end

  it "should not parse without adding a column" do
    @parser.parse!.should be_false
  end
  
  it "should generate output" do
    @parser.add_column "age"
    @parser.add_column "name"
    @parser.from_string "21;andrehjr\n19;foo"
    @parser.parse!
    @parser.output.should_not be_empty
  end
  
  it "should valid output using blocks" do
    @parser.add_column "age"
    @parser.add_column "name" do |value| "'" + value + "-lolzizator'" end
    @parser.from_string "21;andrehjr"
    @parser.parse!
    @parser.output[0].should == "insert into person (age,name) values ('21','andrehjr-lolzizator');"
  end
  
  it "should skip columns" do
    @parser.add_column "age", :skip => true
    @parser.add_column "name" do |value| "'" + value + "-lolzizator'" end
    @parser.from_string "21;andrehjr"
    @parser.parse!
    @parser.output[0].should == "insert into person (name) values ('andrehjr-lolzizator');"
  end
  
  it "should parse correctly reading from a file" do
    @parser.add_column "age", :skip => true
    @parser.add_column "name" do |value| "'" + value + "-lolzizator'" end
    @parser.from_file path("test.csv")
    @parser.parse!
    @parser.output[0].should == "insert into person (name) values ('andrehjr-lolzizator');"
  end
end