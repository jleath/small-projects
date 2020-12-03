require 'minitest/autorun'
require 'minitest/reporters'

MiniTest::Reporters.use!

require_relative 'binary_tree'

class BinaryTreeTest < MiniTest::Test
  NUM_VALUES = 100000

  def setup
    @values = NUM_VALUES.times.map { |_| rand(10000) }  
    @tree = BinaryTree.new
    @tree.add(@values)
  end

  def test_add
    assert_equal(@values.sort, @tree.to_a)
  end

  def test_size
    assert_equal(@values.size, @tree.size)
  end

  def test_find
    @values.each { |val| assert_equal(true, @tree.find(val)) }
  end

  def test_to_a
    tree = BinaryTree.new
    tree.add([12, 15, 3, 0, 22])
    assert_equal([0, 3, 12, 15, 22], tree.to_a)
    assert_equal(@values.sort, @tree.to_a)
  end

  def test_map
    values_squared = @values.sort.map { |value| value ** 2 }
    tree_squared = @tree.map { |value| value ** 2 }
    assert_equal(values_squared, tree_squared)
  end
end