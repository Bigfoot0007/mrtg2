#!/usr/bin/perl

###  Create by Guo Xiang Yong  xyguo@cn.ibm.com for Bluemix
###  Usage: ./linux_cpu.pl remotehost_or_ip

$hostname=$ARGV[0];
$hostname ne "" or $hostname="localhost";

## Get CPU infomation.
sub getcpu{
	$r = ($hostname eq "localhost")? `cat /proc/stat | head -n1`:`/usr/bin/ssh $hostname "cat /proc/stat | head -n1"`;
	if($r=~/cpu  (\d*) (\d*) (\d*) (\d*) (\d*) (\d*) (\d*) (\d*) (\d*) (\d*)/){
	   $idle=$4;
	   $total=$1+$2+$3+$4+$5+$6+$7;
	   return($idle,$total);
	}
}
# caculate the latest 1 second's stat.
($i1,$t1)=getcpu();
sleep 1;
($i2,$t2)=getcpu();

$t=$t2-$t1;
$i=$i2-$i1;
$systemusage=int((1-$i/$t)*10000)/100;

print $systemusage;
