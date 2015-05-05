# -*- coding: utf-8 -*-
#require 'drb/drb'
require_relative 'resourced'

SERVER = "localhost" # 使用するIP
PORT = "11212" # 使用するポート番号
# URI = "druby://" + SERVER + ":" + PORT

Resourced.new(SERVER, PORT).run
# dRubyのサービスを開始
# DRb.start_service(URI, resourced)
# DRb.thread.join
