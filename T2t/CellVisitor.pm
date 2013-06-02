package T2t::CellVisitor;

use strict;
use warnings;

sub new
{
    my $package = shift;
    bless( {}, $package );
}

sub affectRow
{
	# empty implemention, does not do anything
	# must be subclassed to do actual work
}

1;