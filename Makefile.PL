use ExtUtils::MakeMaker;

use 5.008;

WriteMakefile
 ( NAME	 	=> 'Geo::EOP'
 , VERSION	=> '0.13'
 , PREREQ_PM    =>
   { Geo::GML            => 0.13
   , XML::Compile        => '1.00'
   , XML::Compile::Cache => '0.90'

   , Test::More    => 0.54
   , Test::Pod     => '1.00'
   }

 , EXE_FILES    => []
 , AUTHOR       => 'Mark Overmeer'
 , ABSTRACT     => 'Earth Observation Products meta-data'
 , LICENSE      => 'perl'
 );

### used by oodist during production of distribution
sub MY::postamble { <<'__POSTAMBLE' }

# for DIST
RAWDIR          = ../public_html/geo-eop/raw
DISTDIR         = ../public_html/geo-eop/source
LICENSE         = artistic
EXTENDS		= ../XMLCompile:../XMLCache:../GeoGML

# for POD
FIRST_YEAR      = 2008
EMAIL           = perl@overmeer.net
WEBSITE         = http://perl.overmeer.net/geo/
PODTAIL		= ../Geo-ogc-podtail
__POSTAMBLE
