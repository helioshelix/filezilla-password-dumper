#!/usr/bin/perl -w
use strict;
use warnings;
use XML::Simple;
use MIME::Base64;
$|=1;


#my $siteManagerXmlFile = 'sitemanager.xml'; #specific file location
my $siteManagerXmlFile = $ENV{APPDATA} . "\\FileZilla\\sitemanager.xml"; #sitemanager.xml location on Windows

unless(-e $siteManagerXmlFile){
	die "Unable to locate $siteManagerXmlFile\n";
}
print "Reading $siteManagerXmlFile\n\n";

my $xml = new XML::Simple(NormaliseSpace => 2);
my $data = $xml->XMLin($siteManagerXmlFile);

for my $server(@{$data->{Servers}->{Server}})
{
	my $serverName = $server->{Name};
	my $username = '<none specified>';
	my $password = '<none specified>';
	my $host = $server->{Host};
	if(exists($server->{User})){
		$username = $server->{User};
	}
	if(exists($server->{Pass})){
		$password = decode_base64($server->{Pass}->{content});
	}
	print "$serverName | $host $username:$password\n";
}
