ssh-host-config --yes
net start cygserver
mount -f -s -b "D:/cygwin/bin" "/usr/bin"
mount -f -s -b "D:/cygwin/lib" "/usr/lib"
mount -f -s -b "D:cygwin/" "/"
mount -f -s -b "D:/cygwin/" "/"
ssh-host-config --yes
net start sshd