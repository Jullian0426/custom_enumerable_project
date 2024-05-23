module Enumerable
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    for i in 0...self.length
      yield(self[i], i)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    result = []
    self.my_each { |elem| result << elem if yield(elem) }
    result
  end

  def my_all?
    return true unless block_given?
    self.my_each { |elem| return false unless yield(elem) }
    true
  end

  def my_any?
    return true unless block_given?
    self.my_each { |elem| return true if yield(elem) }
    false
  end

  def my_none?
    return true unless block_given?
    self.my_each { |elem| return false if yield(elem) }
    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      self.my_each { |elem| count += 1 if yield(elem) }
    elsif item
      self.my_each { |elem| count += 1 if elem == item }
    else
      return self.length
    end
    count
  end

  def my_map
    return to_enum(:my_map) unless block_given?
    result = []
    self.my_each { |elem| result << yield(elem) }
    result
  end

  def my_inject(initial = nil, sym = nil)
    if initial.nil?
      accumulator = self.first
      self.drop(1).my_each { |elem| accumulator = yield(accumulator, elem) }
    elsif initial.is_a?(Symbol) or initial.is_a?(String)
      sym = initial
      accumulator = self.first
      self.drop(1).my_each { |elem| accumulator = accumulator.send(sym, elem) }
    else
      accumulator = initial
      self.my_each { |elem| accumulator = yield(accumulator, elem) }
    end
    accumulator
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each
    return to_enum(:my_each) unless block_given?
    for i in 0...self.length
      yield(self[i])
    end
    self
  end
end
