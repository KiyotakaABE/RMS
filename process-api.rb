#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'socket'
require 'thread'

DEBUG = true
if DEBUG
  require_relative 'test/dummy-process'
end

class ProcessAPI  
  DELTA = -10 # 変更する資源の量
  SLEEP_TIME = 60 # 資源量変更から性能測定までの時間
  FREQUENCY = 2 # 測定頻度

  def initialize(host, port)
    if DEBUG
      @process = DummyProcess.new
    else
      @sock = TCPSocket.open(host, port)
    end
    
    # 等価交換比率測定スレッドを起動
    # ratioはwriteするスレッドは1つだけなので
    # 排他制御の必要はなし
    @ratio = nil
    Thread.start {
      loop{
        @ratio = estimate
        sleep(FREQUENCY)
      }
    }
  end
  
  private
  def measure_throughput
    # throughputを測定する
  end
  
  def change_mem
  end

  def change_cpu
  end

  def calculate_price(delta, before, after)
  end

  def estimate
    if DEBUG
      return @process.estimate
    end
    
    before = measure_throughput()
    change_mem(DELTA)
    sleep(SLEEP_TIME)
    after = measure_throughput()
    change_mem(-DELTA)
    ratio = calculate_price(delta, before, after)
    return ratio
  end

  public
  def process_info
    if DEBUG
      return @process.process_info
    end
    # プロセスの情報を返す
  end
  
  def change_ratio(price)
    # priceに応じて比率を変更する
    if DEBUG
      @process.change_ratio(price)
      @ratio = estimate # これをここでやるかはあとで再考する必要あり
    end
  end
  
  # ratioのreader
  def ratio
    while @ratio.nil? do end
    return @ratio
  end 
  
  # test用
  def pid
    if DEBUG
      @process.pid
    end
  end
end
