class Column
  attr_accessor :callback, :name, :options

  @@DEFAULT_CALLBACK = lambda { |value| "'#{value}'" }
  
  def initialize(name, options = {}, &block)
    @name = name
    @options = options
    if block_given? 
      @callback = block
    else
      @callback = @@DEFAULT_CALLBACK
    end
  end
  
  def evaluate(value)
    callback.call(value)
  end
end