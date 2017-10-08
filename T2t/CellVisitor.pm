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

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.html for details
