#!/usr/local/bin/python
#
# for example by mind@metalshell.com
#
# an example on for loops
#
# 03/12/2002
#
# http://www.metalshell.com
#
 
# the range() function lays out a range between integers.
# range(0,10) would look like: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
 
# for each num in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
 
# go through each element in range()
for num in range(0, 10):
  # print each number
  print num
 
 
# heres an example on finding duplicate strings using for.
 
# define our sequence of strings
names = ['John', 'Mark', 'Henry', 'Mark', 'Marie']
 
# this will sort all the strings in our sequence
names.sort()
 
# define our strings and integers for our for statement
dup_count = 0
prev = names[0]
del names[0]
 
for name in names:
  if prev == name:
    dup_count = dup_count + 1
    print "Duplicate found:", name
  prev = name
 
if dup_count == 0:
  print "Done! no duplicates were found"
else:
  print "Total duplicates found:", dup_count


