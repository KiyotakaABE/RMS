#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'socket'
require 'timeout'
require_relative 'message-protocol'

class ResourcedAPI
  include MessageProtocol

  def initialize(host, port)
    @sock = TCPSocket.open(host, port)
  end
  
  def update(pid, pinfo, price)
    # メッセージを作って送る
    msg = make_update(pid, pinfo, price)
    @sock.puts(msg)
  end

  def recv(time)
    begin
      timeout(time){
        msg = @sock.gets
      }
      return parse_resourced(msg)
    rescue Timeout::Error
      # STDERR.puts "ResourcedAPI:Timeout"
      return nil
    end
  end
end
