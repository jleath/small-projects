class BinaryTree
  attr_reader :size

  include Enumerable 

  def initialize()
    @size = 0
  end

  def empty?
    size.zero?
  end

  # Increment size no matter what
  # If the current binary tree is empty, set the value to the argument and return
  # Otherwise, if the argument is <= than the current tree's value, add the value to the left child
  # If the argument is > than the current tree's value, add the value to the left child
  def add(value)
    if value.instance_of?(Array)
      value.each { |val| add(val) }
      return
    end

    if empty?
      self.size += 1
      self.value = value
      return
    end

    self.size += 1
    if value <= self.value
      self.left = BinaryTree.new if left.nil?
      left.add(value)
    else
      self.right = BinaryTree.new if right.nil?
      right.add(value)
    end
  end

  def find(value)
    return false if empty?
    return true if self.value == value

    if value < self.value
      return false if left.nil?
      left.find(value)
    else
      return false if right.nil?
      right.find(value)
    end
  end

  def each(&blk)
    return if empty?

    left.each(&blk) unless left.nil?
    blk.call(value)
    right.each(&blk) unless right.nil?
  end

  def to_a
    map { |value| value }
  end

  private

  attr_accessor :value, :left, :right
  attr_writer :size
end