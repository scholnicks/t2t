package T2t::BaseClass;

use strict;
use warnings;

sub new
{
    my $package = shift;
    bless( {}, $package );
}

sub isQuiet						# shortcut method for child classes
{
	my $self = shift;
    return $self->getPreferencesCache()->isQuiet();
}

sub isVerbose					# shortcut method for child classes
{
	my $self = shift;
    return $self->getPreferencesCache()->isVerbose();
}

sub getPreferencesCache			# shortcut method for child classes
{
	my $self = shift;
	return T2t::UserPreferencesCache::getInstance();
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000- Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.html for details
