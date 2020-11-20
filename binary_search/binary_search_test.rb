require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative 'binary_search'

class BinarySearchTest < MiniTest::Test
  def test_simple_sort
    arr = [1, 2, 3, 4, 5, 6]
    assert_equal(4, binary_search(arr, 5))
    assert_equal(0, binary_search(arr, 1))
    assert_equal(5, binary_search(arr, 6))
  end

  def test_missing_item
    arr = [1, 2, 3, 4, 5, 6]
    assert_nil(binary_search(arr, 7))
  end

  def test_one_item
    arr = [0]
    assert_equal(0, binary_search(arr, 0))
    assert_nil(binary_search(arr, 5))
  end

  def test_empty_array
    arr = []
    assert_nil(binary_search(arr, 1))
  end

  def test_duplicate_values
    arr = [1, 1, 1, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 7]
    assert_equal(8, binary_search(arr, 4))
    assert_equal(4, binary_search(arr, 3))
    assert_equal(11, binary_search(arr, 6))
    assert_equal(0, binary_search(arr, 1))
  end

  def test_large_case
    arr_size = 100_000_000
    max_value = 1_000_000
    num_assertions = 100
    large_arr = (0..arr_size).to_a
    num_assertions.times do |_|
      value = rand(max_value)
      assert_equal(value, binary_search(large_arr, value)) 
    end
    num_assertions.times do |_|
      value = -rand(max_value)
      assert_nil(binary_search(large_arr, value))
    end
  end
end