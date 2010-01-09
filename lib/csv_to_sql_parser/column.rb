class Column
  attr_accessor :callback, :name, :options
  
  def initialize(name, options = {}, &block)
    @name = name
    @options = options
    @callback = block if block_given?
  end
  
  def evaluate(value)
    if callback.nil?
      "'#{value}'"
    else
      callback.call(value)
    end
  end
end