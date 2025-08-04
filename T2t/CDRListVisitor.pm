package T2t::CDRListVisitor;

use strict;
use warnings;

use T2t::Row;
use Cwd;
use POSIX;
use Splice::Utilities;

use base qw( T2t::CellVisitor );

sub new
{
    my $package = shift;
    my $self  = {};

    $self->{listMap} = {};

    bless( $self, $package );

    $self->readSetsFiles();

    $self;
}

sub affectRow
{
	my $self = shift;
	my $row  = shift;

	my $bandCell   = $row->getCell(0);
	my $titleCell  = $row->getCell(1);
	my $titleData  = $titleCell->getData();
	my $bandData   = $bandCell->getData();

	my $normalized = normalizeText($bandData . $titleData);

	return if( ! $normalized );
	return if( $normalized eq 'artistcitydateother' );

	if( defined $self->{listMap}->{$normalized} )
	{
		$titleCell->setData( $self->getTitleData($titleData,$normalized,$bandData) );
	}
	else
	{
		print "$normalized\n";
	}
}

sub getTitleData
{
	my $self        = shift;
	my $currentData = shift;
	my $normalized  = shift;
	my $bandData    = shift;

	'<a href="' .
	$self->{listMap}->{$normalized} .
	'">' .
	$currentData .
	'</a>'
}

sub readSetsFiles
{
	my $self = shift;
	my $setsPath = '/Users/steve/sets';
	my $setsRootURL = 'http://www.scholnick.net/setlists/';

	foreach my $file ( 'sets.a-g','sets.h-n','sets.o-r','sets.s-z', 'zeppelin' )
	{
		my $path = getPath($setsPath,$file);

		my @text = getFileAsArray($path);

		my $normalized = normalizeText($text[0]);
		$self->{listMap}->{$normalized} = $setsRootURL . $file . '.html#' . $normalized;

		for(my $i = 1; $i < $#text; $i++)
		{
			if($text[$i] =~ /^#/ )
			{
				$i++;
				$normalized = normalizeText($text[$i]);
				$self->{listMap}->{$normalized} = $setsRootURL . $file . '.html#' . $normalized;
			}
		}
	}
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000- Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details
