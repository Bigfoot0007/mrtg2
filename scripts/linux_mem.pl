#!/usr/bin/perl

###  Create by Guo Xiang Yong  xyguo@cn.ibm.com for Bluemix
###  Usage: ./linux_cpu.pl remotehost_or_ip

$hostname=$ARGV[0];
$hostname ne "" or $hostname="localhost";

## Get Memory infomation.
sub getmem{
	my $r = ($hostname eq "localhost")? `cat /proc/meminfo`:`/usr/bin/ssh $hostname "cat /proc/meminfo"`;
	if($r=~/MemTotal:\s*(.*) kB/) 	{ $MemTotal=$1; 	}
	if($r=~/MemFree:\s*(.*) kB/)	{ $MemFree=$1;	}
	return($MemTotal,$MemFree);
}
# caculate the latest 1 second's stat.
($MemTotal,$MemFree)=getmem();

# print $MemTotal."-".$MemFree;
$usage=int((($MemTotal-$MemFree)/$MemTotal)*10000)/100;

print $usage;


