# Copyrights 2008 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.05.
use warnings;
use strict;

package Geo::EOP;
use vars '$VERSION';
$VERSION = '0.10';

use base 'XML::Compile::Cache';

use Geo::EOP::Util;   # all

use Log::Report 'geo-eop', syntax => 'SHORT';
use XML::Compile::Util  qw/unpack_type pack_type/;
use Math::Trig          qw/rad2deg deg2rad/;

# map namespace always to the newest implementation of the protocol
my %ns2version =
  ( &NS_HMA_ESA => '1.0'
  , &NS_EOP_ESA => '1.1'
  );

# list all available versions
my %info =
  ( '1.0'     =>
      { prefixes => {hma => NS_HMA_ESA, ohr => NS_OHR_ESA}
      , schemas  => [ 'hma1.0/*.xsd' ] }

  , '1.1'     =>
      { prefixes => {eop => NS_EOP_ESA, opt => NS_OPT_ESA}
      , schemas  => [ 'eop1.1/*.xsd' ] }

  , '1.2beta' =>
      { prefixes => {eop => NS_EOP_ESA, opt => NS_OPT_ESA}
      , schemas  => [ 'eop1.2beta/*.xsd'
                    , 'eop1.1/gmlSubset.xsd'
                    ] }
  );

my %measure =
  ( rad_deg   => sub { rad2deg $_[0] }
  , deg_rad   => sub { deg2rad $_[0] }
  , '%_float' => sub { $_[0] / 100 }
  , 'float_%' => sub { sprintf "%.2f", $_[0] / 100 }
  );
sub _convert_measure($@);

# This list must be extended, but I do not know what people need.
my @declare_always = ();


sub new($@)
{   my ($class, $dir) = (shift, shift);
    $class->SUPER::new(direction => $dir, @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{allow_undeclared} = 1
        unless exists $args->{allow_undeclared};

    $self->SUPER::init($args);

    $self->{GE_dir} = $args->{direction} or panic "no direction";

    my $version     =  $args->{version}
        or error __x"EOP object requires an explicit version";

    unless(exists $info{$version})
    {   exists $ns2version{$version}
            or error __x"EOP version {v} not recognized", v => $version;
        $version = $ns2version{$version};
    }
    $self->{GE_version} = $version;    
    my $info    = $info{$version};

    $self->prefixes
      ( xlink => NS_XLINK_1999, gml => NS_GML_311
      , sar => NS_SAR_ESA, atm => NS_ATM_ESA
      , %{$info->{prefixes}}
      );
    $self->addKeyRewrite('PREFIXED(sar,atm,ohr,opt)');

    (my $xsd = __FILE__) =~ s!\.pm!/xsd!;
    my @xsds    = map {glob "$xsd/$_"}
        @{$info->{schemas}}, 'xlink1.0.0/*.xsd';

    $self->importDefinitions(\@xsds);

    my $units = delete $args->{units};
    if($units)
    {   if($units->{angle})
        {   $self->addHook(type => pack_type(NS_GML_311, 'AngleType')
               , after => sub { _convert_measure $units->{angle}, @_} );
        }
        if($units->{distance})
        {   $self->addHook(type => pack_type(NS_GML_311, 'MeasureType')
               , after => sub { _convert_measure $units->{distance}, @_} );
        }
        if($units->{percentage})
        {   $self->addHook(path => qr/Percentage/
               , after => sub { _convert_measure $units->{percentage}, @_} );
        }
    }

    $self;
}

sub declare(@)
{   my $self = shift;

    my $direction = $self->direction;

    $self->declare($direction, $_)
        for @_, @declare_always;

    $self;
}

#---------------------------------


sub version()   {shift->{GE_version}}
sub direction() {shift->{GE_dir}}


sub printIndex(@)
{   my $self = shift;
    my $fh   = @_ % 2 ? shift : select;
    $self->SUPER::printIndex($fh
      , kinds => 'element', list_abstract => 0, @_); 
}

#---------------------
# This code will probaby move to Geo::GML

sub _convert_measure($@)   # not $$$$ for right context
{   my ($to, $node, $data, $path) = @_;
    ref $data eq 'HASH'  or return $data;
    my ($val, $from) = @$data{'_', 'uom'};
    defined $val && $from or return $data;

    return $val if $from eq $to;
    my $code = $measure{$from.'_'.$to} or return $data;
    $code->($val);
}

#----------------------


1;
