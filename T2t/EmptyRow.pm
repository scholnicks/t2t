package T2t::EmptyRow;

use strict;
use warnings;

use T2t::Cell;
use T2t::UserPreferencesCache;
use T2t::Utilities;

use base qw( T2t::Row );

sub new
{
    my $package = shift;
    my $self    = {};

    $self->{header}      = shift || 0;
    $self->{attrs}       = T2t::UserPreferencesCache::getInstance()->getRowAttributes();

    bless( $self, $package );

	$self->{_data} = [];

    $self;
}

sub setNumberOfColumns
{
	my $self        = shift;
	my $columnCount = shift;

	my @cellData;
	push(@cellData,new T2t::Cell('',1)) foreach( 1 .. $columnCount );
	$self->{_data} = \@cellData;
}

sub isEmpty { return 1; }

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details
