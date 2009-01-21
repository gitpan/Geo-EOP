#!/usr/bin/perl
use warnings;
use strict;

#use Log::Report mode => 3;  #debugging
use Geo::EOP::Envisat;

my $version = '1.2.1';

@ARGV==1
   or die "ERROR: one filename required";

my ($filename) = @ARGV;

my $eop = Geo::EOP::Envisat->new
  ( 'WRITER'
  , eop_version => $version
  );

my $xml = $eop->convert($filename);
print $xml->toString(1);
