class Node
  attr_accessor :left, :right, :value

  def initialize(left = nil, right = nil, value = nil)
    @left = left
    @right = right
    @value = value
  end
end

class LinkedListError < StandardError; end

class LinkedListDeque
  attr_reader :size

  def initialize
    @sentinel = Node.new
    @sentinel.left = @sentinel
    @sentinel.right = @sentinel
    @size = 0
  end

  def add_first(value)
    new_first = Node.new(@sentinel, @sentinel.right, value)
    new_first.right.left = new_first
    @sentinel.right = new_first
    @size += 1
    nil
  end

  def remove_first
    raise LinkedListError, 'remove_first: empty deque' if empty?

    first = @sentinel.right
    @sentinel.right = first.right
    first.right.left = @sentinel
    @size -= 1
    first.left = nil
    first.right = nil
    first.value
  end

  def add_last(value)
    new_last = Node.new(@sentinel.left, @sentinel, value)
    new_last.left.right = new_last
    @sentinel.left = new_last
    @size += 1
    nil
  end

  def remove_last
    raise LinkedListError, 'remove_last: empty deque' if empty?

    last = @sentinel.left
    @sentinel.left = last.left
    last.left.right = @sentinel
    @size -= 1
    last.left = nil
    last.right = nil
    last.value
  end

  def get(index)
    raise LinkedListError, "get: out of range [#{index}]" if index >= @size

    curr_node = @sentinel.right
    while index.positive?
      curr_node = curr_node.right
      index -= 1
    end
    curr_node.value
  end

  def empty?
    @size.zero?
  end

  def to_s
    values = []
    next_node = @sentinel.right
    while next_node != @sentinel
      values << next_node.value
      next_node = next_node.right
    end
    values.to_s
  end
end
