#!/usr/bin/perl

$hostname=$ARGV[0];
$hostname ne "" or $hostname="localhost";
$r = `ping $hostname -c 1 | grep "packet loss"`;

if($r=~/received, (.*) packet loss/){
	print($1);
	exit(0);
}
exit(-1);
