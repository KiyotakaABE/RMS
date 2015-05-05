#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'drb/drb'
require_relative 'process-api'

class Agent
  attr_reader :pid

  SLEEP = 10

  def initialize(ip_process, port_process, ip_resourced, port_resourced)
    # 1つのプロセスでテストするときは下のを使う
    # @pid = Process::pid
    @resourced = DRbObject.new_with_uri('druby://' + ip_resourced + ':' + port_resourced);
    @process = ProcessAPI.new(ip_process, port_process)
    @pid = @process.pid

    # 公開するオブジェクトを生成
    drb = DRb.start_service(nil, self)
    # 公開URIを取得し，observerとしてresourcedにaddする
    @resourced.add_observer(drb.uri)
  end

  # Resourcedからの資源変更通知
  def notify(price)
    @process.change_ratio(price)
  end

  def update
    @resourced.update(@pid, @process.process_info, @process.ratio)
  end
  
  def delete
    @resourced.delete(@pid)
  end

  def run
    loop{
      update
      sleep(SLEEP)
    }
  end    
end
