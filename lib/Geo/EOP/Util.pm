# Copyrights 2008 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.05.
use warnings;
use strict;

package Geo::EOP::Util;
use vars '$VERSION';
$VERSION = '0.10';

use base 'Exporter';

our @gml311    = qw/NS_GML NS_GML_311 NS_XLINK_1999/;
our @hmas      = qw/NS_ATM_ESA NS_OHR_ESA NS_SAR_ESA NS_HMA_ESA/;
our @eops      = qw/NS_ATM_ESA NS_OPT_ESA NS_SAR_ESA NS_EOP_ESA/;

our @EXPORT    = (@gml311, @hmas, @eops);

our @EXPORT_TAGS =
 ( hma10     => [ @gml311, @hmas ]
 , eop11     => [ @gml311, @eops ]
 , eop12beta => [ @gml311, @eops ]
 );


use constant NS_ATM_ESA => 'http://earth.esa.int/atm';
use constant NS_SAR_ESA => 'http://earth.esa.int/sar';

use constant NS_GML     => 'http://www.opengis.net/gml';
use constant NS_GML_311 => NS_GML;
use constant NS_XLINK_1999 => 'http://www.w3.org/1999/xlink';

# HMA before renaming
use constant NS_OHR_ESA => 'http://earth.esa.int/ohr';
use constant NS_HMA_ESA => 'http://earth.esa.int/hma';

# EOP renaming
use constant NS_OPT_ESA => 'http://earth.esa.int/opt';
use constant NS_EOP_ESA => 'http://earth.esa.int/eop';

1;
