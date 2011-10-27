#!/usr/bin/python
import cmemcached
import struct
import socket
import re
import os, sys
import signal

def Test( host ):
	signal.signal(signal.SIGPIPE, signal.SIG_DFL)
	KEYS = ["IPLISTKEY", "ACLOGINLIST", "ACBLACKLIST"]
	row = ""
	print ( 'host = %s' % host )
	mc = cmemcached.Client( [ host ] )
	data = {}
	data_range = {}
	biggest_key = ""

	for key in KEYS:
		data[key] = mc.get(key)
		if data[key] is None:
			data[key] = []
			
		data_range[key] = range(len(data[key])/4)
		if key == KEYS[0]:
			row = "\n        %-23s" % key
			biggest_key = key
		else:
			row += "|        %-23s" % key
			if len(data[key]) > len(data[biggest_key]):
				biggest_key = key

	print row

	for i in data_range[biggest_key]:

		for key in KEYS:
			ip = ""
			if i in data_range[key]:
				ip = socket.inet_ntoa(struct.pack('!I', struct.unpack('I', data[key][i*4: (i+1) * 4])[0]))

			if key == KEYS[0]:
				row = "        %-23s" % ip
			else:
				row += "|        %-23s" % ip

		print row

if __name__ == '__main__' :
  
    argc = len ( sys.argv )
    if argc == 2 :
      host = '%s:11211' % ( sys.argv[1] )
      Test( host )
    elif argc == 3:
      host = '%s:%s' % ( sys.argv[1], sys.argv[2] )
      Test( host )
    else :
      Test( '127.0.0.1:11211')

