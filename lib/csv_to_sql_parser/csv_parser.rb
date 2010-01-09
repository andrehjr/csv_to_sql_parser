class CsvParser
  attr_reader :columns, :lines, :output
  attr_accessor :table
  def initialize
    reset!
  end
  
  def add_column(value, options = {}, &block)
    @columns << Column.new(value, options, &block)
  end
  
  def parse!
    if @lines.empty? or @columns.empty?
      false
    else
      generate_sqls
    end
  end
  
  def generate_sqls
    fields_list = @columns.reject { |column| column.options[:skip] }.map { |column| column.name }.join","
    
    @lines.each do |line|
      hash = map_to_columns line
      
      str = "insert into " + @table + " (" + fields_list + ") values (" + evaluate_columns(hash) + ");"
      @output << str
    end
  end
  
  def from_file(filename)
    File.open(filename).each_line do |line|
      @lines << line.gsub(/\n/, "")
    end
  end
  
  def reset!
    @columns = []
    @lines = []
    @output = []
  end
  
  def from_string(data)
    data.split("\n").each do |line|
      @lines << line
    end
  end
  
  private 
  def map_to_columns line
    h = {}
    values = line.split ";"
    
    @columns.each_with_index do |column, index|
      h[column.name] = values[index]
    end
    h
  end
  
  def evaluate_columns hash
    list = []
    @columns.reject { |column| column.options[:skip] }.each do |column|
      list << column.evaluate(hash[column.name]) unless column.options[:skip]
    end
    list.join ","
  end
end