#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'thread'

class DummyProcess
  # ratioを変化させる頻度
  RAND_FREQUENCY = 5
  @@num = 0
  
  def initialize
    @ratio = rand(0.0..2.0)
    @num = @@num
    @@num += 1
    my_print("initial_ratio:" + @ratio.to_s)
    Thread.start{
      loop{
        sleep(RAND_FREQUENCY)
        # 標準出力の都合上ちょっと遅らせてる
        sleep(0.001) if @num == 1
        sleep(0.001) if @num == 2
        delta = rand(-0.2..0.2)
        @ratio += delta
        my_print("new_ratio:" + @ratio.to_s + ", delta: " + delta.to_s)
      }
    }
  end

  def estimate
    return @ratio
  end

  def process_info
    return nil
  end

  def change_ratio(price)
    @ratio = price
    my_print("change_ratio:" + @ratio.to_s)
  end

  # test用
  def pid
    return @num
  end

  def my_print(str)
    puts "DummyProcess-" + @num.to_s + ":" + str    
  end
end
