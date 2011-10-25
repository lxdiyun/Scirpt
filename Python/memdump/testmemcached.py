#!/usr/bin/python
import cmemcached
import struct
import socket
import re
import os, sys
import signal

def Test( host ):
	signal.signal(signal.SIGPIPE, signal.SIG_DFL)

	print ( 'host = %s' % host )
	mc = cmemcached.Client( [ host ] )
	print ("\n        %-23s|        %-23s|        %-23s" % ("IPLISTKEY", "ACLOGINLIST", "ACBLACKLIST")) 
	data = [mc.get("IPLISTKEY"), mc.get("ACLOGINLIST"), mc.get("ACBLACKLIST")]
	data_range = [range(len(data[0])/4), range(len(data[1])/4), range(len(data[2])/4)] 
	
	biggest_range = data_range[0] 

	if len(data[0]) < len(data[1]):
		biggest_range = data_range[1]

	for i in biggest_range:
		ip0 = ""
		ip1 = ""
		ip2 = ""
		if i in data_range[0]:
			ip0 = socket.inet_ntoa(struct.pack('!I', struct.unpack('I', data[0][i*4: (i+1) * 4])[0]))

		if i in data_range[1]:
			ip1 = socket.inet_ntoa(struct.pack('!I', struct.unpack('I', data[1][i*4: (i+1) * 4])[0]))

		if i in data_range[2]:
			ip2 = socket.inet_ntoa(struct.pack('!I', struct.unpack('I', data[2][i*4: (i+1) * 4])[0]))

		print ("        %-23s|        %-23s|        %-23s" % (ip0, ip1, ip2))


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

