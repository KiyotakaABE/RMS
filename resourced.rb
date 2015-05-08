#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'drb/drb'
require_relative 'market'
require_relative 'order'

class Resourced
  attr_reader :market
  
  def initialize(ip, port)
    @market = Market.new(self)
    @observers = Hash.new
    @uri = "druby://" + ip + ":" + port
  end
  
  private
  def calculate_price(order1, order2)
    return (order1.price + order2.price) / 2 
  end
  
  public
  # marketからの通知
  def notify(order1, order2)
    # デバッグ用プリント
    puts("(RD    ) select :" + "(PNum-" + order1.pid.to_s + ") & (Pnum-" + order2.pid.to_s + ")")
    price = calculate_price(order1, order2)
    t1 = Thread.start{
      order1.notify(price)
    }
    t2 = Thread.start{
      order2.notify(price)
    }
    t1.join; t2.join
  end

  def update(pid, pinfo, price)
    # marketのupdateメソッド呼び出し
    order = Order.new(pid, pinfo, price, @observers.fetch(pid))
    @market.update(order)
  end

  def delete(pid)
    @market.delete(pid)
    @observers.delete(pid)
  end

  def add_observer(uri)
    observer = DRbObject.new_with_uri(uri)
    @observers.store(observer.pid, observer)
  end

  def run
    DRb.start_service(@uri, self)
#    DRb.thread.join
  end
end
