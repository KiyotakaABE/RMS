#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'thread'

class DummyProcess
  # ratioを変化させる頻度
  #  RAND_FREQUENCY = 5
  @@num = 0
  
  def initialize
    @ratio = rand(0.0..2.0)
    @num = @@num
    @@num += 1
    my_print("initial:" + @ratio.to_s)
=begin
    Thread.start{
      loop{
        sleep(RAND_FREQUENCY)
        # 標準出力の都合上ちょっと遅らせてる
        sleep(0.001) if @num == 1
        sleep(0.001) if @num == 2
        delta = rand(-0.2..0.2)
        @ratio += delta
        # my_print("new    :" + @ratio.to_s + " (delta: " + delta.to_s + ")")
      }
    }
=end
  end

  def estimate
    return @ratio
  end

  def process_info
    return nil
  end

  def change_ratio(price)
    @ratio = price
    my_print("changed:" + @ratio.to_s)
  end

  # test用
  def pid
    return @num
  end

  def my_print(str)
    puts "(PNum-" + @num.to_s + ") " + str    
  end
end
