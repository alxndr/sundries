require "minitest/autorun"
require_relative "quicksort"

class QuicksortTest < MiniTest::Unit::TestCase

  def test_forwards
    result = Quicksort.sort([1, 2, 3, 4, 5])
    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_backwards
    result = Quicksort.sort([5, 4, 3, 2, 1])
    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_huge_forwards
    result = Quicksort.sort((0..999).to_a)
    assert_equal (0..999).to_a, result
  end

  def test_huge_jumbled
    list = (0..999).to_a
    result = Quicksort.sort(list.shuffle)
    assert_equal (0..999).to_a, result
  end

  def test_huge_backwards
    result = Quicksort.sort((0..999).to_a.reverse)
    assert_equal (0..999).to_a, result
  end

end
