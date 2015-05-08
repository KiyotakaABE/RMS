#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'minitest/unit'
require_relative '../resourced'
require_relative '../market'
require_relative '../order'

Minitest::Unit::autorun

class TestResourced < MiniTest::Unit::TestCase
  def setup
    @resourced = Resourced.new("localhost", "11212")
    @market = @resourced.market
  end

  def test
    # orderを1つ追加
    order01 = Order.new(1, nil, 0.5, nil)
    @market.update(order01)
    assert_equal([order01], @market.array)

    # 削除
    @market.delete(order01.pid)
    assert_equal([], @market.array)

    # order2つ目を追加
    order02 = Order.new(2, nil, 0.7, nil)
    @market.update(order01)
    @market.update(order02)
    assert_equal([order01, order02], @market.array)
    
    # order3つ目を配列の中間になるように追加
    order03 = Order.new(3, nil, 0.6, nil)
    @market.update(order03)
    assert_equal([order01, order03, order02], @market.array)

    # order4つ目を配列の先頭なるように追加
    order04 = Order.new(4, nil, 0.1, nil)
    @market.update(order04)
    assert_equal([order04, order01, order03, order02], @market.array)
  
    # 存在しないorderを削除
    @market.delete(0)
    assert_equal([order04, order01, order03, order02], @market.array)
  end
end
