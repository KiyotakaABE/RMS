#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'process-api'
require_relative 'agent'

# SLEEP = 60
PORT_RESOURCED = '11212'
PORT_PROCESS = '11211'
IP_RESOURCED = 'localhost'
IP_PROCESS = 'localhost'

Agent.new(IP_PROCESS, PORT_PROCESS, IP_RESOURCED, PORT_RESOURCED).run
