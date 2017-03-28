#!/usr/bin/perl

# this is tcpping tools, write by xyguo@cn.ibm.com 2017.01.22
# for check ip+port is connectable or not.

use Socket;

# initialize host and port
my $host = shift || 'localhost';
my $port = shift || 7890;
my $server = "localhost";  # Host IP running the server

$proto = getprotobyname('tcp');    #get the tcp protocol
 
# 1. create a socket handle (descriptor)
my($sock);
socket($sock, AF_INET, SOCK_STREAM, $proto) or die "[FAILED] Can't create a socket $!\n";
 
# 2. connect to host server

$iaddr = inet_aton($host) or die "[FAILED] Unable to resolve hostname : $host";
$paddr = sockaddr_in($port, $iaddr);    #socket address structure
 
if(!connect($sock,$paddr)){
	print "[FAILED] connect failed : $!";
	exit(-1);
}
close($sock);

print "[OK] Connected to $remote on port $port\n";

exit(0); 


