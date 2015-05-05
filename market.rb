#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'date'


# memo
# マーケットで扱うorderは，複数のスレッドから同時にアクセスされる場合があるので，market自体を排他的に制御する必要がある．あるスレッドがmarketをいじっているときは，他のスレッドを待たせる必要がある．

class Market
  attr_reader :array

  def initialize(observer)
    @observer = observer
    @array = []
    @history = History.new
  end

  private
  def sort
    @array.sort!{|a, b| a.price <=> b.price}
  end

  public
  def delete(pid)
    # orderを削除
    @array.delete_if{
      |item| item.pid == pid
    }
    @history.delete(pid)
  end
  
  def update(order)
    # orderを新規追加 または更新
    delete(order.pid)
    @array.push(order)
    sort
    # resourcedに通知
    notify_observer
  end

  # ペア選択の戦略は全てこのメソッドで処理する
  # ここだけ変えれば，ペア戦略戦略を全て変えられるようにしておく
  # この部分の挙動がちょっと怪しいので，あとでバグが出るかも
  def choose_pair
    # リストの要素が1または0個のとき
    if array.length >= 2
      # 先頭から最近選んでいないorderを取り出す
      head = nil; index_head = 0
      for h in 0..(@array.length - 1)
        head = @array[h]
        index_head = h
        break unless @history.recent_order?(head)
      end
      
      # 末尾から最近選んでいないorderを取り出す
      tail = nil; index_tail = @array.length - 1
      (@array.length - 1).downto(0){ |t|
        tail = @array[t]
        index_tail = t 
        break unless @history.recent_order?(tail)
      }

      # headのindexがtailのindexを追い越していなければreturn
      if index_head < index_tail
        @history.add(head, tail)
        return head, tail
      end
    end     
    return nil, nil
  end
    
  # observerへの通知
  def notify_observer
    p1, p2 = choose_pair
    if !p1.nil? && !p2.nil?
      @observer.notify(p1, p2)
    end
  end
end

# 連続で同じプロセスに交換指示を出すのを防ぐ仕組み
# ”連続”の間隔は，クラス内のINTERVAL定数で調節
class History
  # INTERVAL秒より短い間隔で資源交換しない
  INTERVAL = 1

  def initialize
    @history = Hash.new
  end
  
  def add(order1, order2)
    now = Time.now
    @history.store(order1.pid, now)
    @history.store(order2.pid, now)
  end

  def delete(pid)
    @history.delete(pid)
  end

  def recent_order?(order)
    now = Time.now
    begin
      time = @history.fetch(order.pid)
      return true if (now - time).abs < INTERVAL
    rescue
      return false
    end
    return false
  end
end
