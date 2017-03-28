#!/usr/bin/perl

###  Create by Guo Xiang Yong  xyguo@cn.ibm.com for Bluemix
###  Usage: ./linux_cpu.pl remotehost_or_ip
###   每一个cpu快照均为(user、nice、system、idle、iowait、irq、softirq、stealstolen、guest)的9元组;
###  > cat /proc/stat
###  cpu  2255 34 2290 22625563 6290 127 456
###  cpu0 1132 34 1441 11311718 3675 127 438
###  cpu1 1123 0 849 11313845 2614 0 18
###  intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
###  ctxt 1990473
###  btime 1062191376
###  processes 2915
###  procs_running 1
###  procs_blocked 0
### 计算方法：
### 、  采样两个足够短的时间间隔的Cpu快照，分别记作t1,t2，其中t1、t2的结构均为：
### (user、nice、system、idle、iowait、irq、softirq、stealstolen、guest)的9元组;
### 2、  计算总的Cpu时间片totalCpuTime
###        把第一次的所有cpu使用情况求和，得到s1;
###       把第二次的所有cpu使用情况求和，得到s2;
###        s2 - s1得到这个时间间隔内的所有时间片，即totalCpuTime = j2 - j1 ;
### 计算空闲时间idle
###  idle对应第四列的数据，用第二次的第四列 - 第一次的第四列即可
###  idle=第二次的第四列 - 第一次的第四列
###  6、计算cpu使用率
###  pcpu =100* (total-idle)/total

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
