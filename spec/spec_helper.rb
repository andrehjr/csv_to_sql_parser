require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../lib/csv_to_sql_parser.rb'

def path(file_name)
   File.dirname(__FILE__) + '/../spec/files/' + file_name
end