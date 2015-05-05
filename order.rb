#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
class Order
  attr_accessor :price, :pinfo, :pid

  def initialize(pid, pinfo, price, observer)
    @price = price
    @pinfo = pinfo
    @pid = pid
    @observer = observer
  end

  def notify(price)
    # for test-market.rb
    #    puts "change: pid->" + @pid.to_s + ", current_price->" + @price.to_s + ", new_price->" + price.to_s
    @observer.notify(price)
  end
end
