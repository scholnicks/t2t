package T2t::PreferencesFileReader;

use strict;
use warnings;

use T2t::Utilities;
use T2t::BaseClass;

use overload q{""} => \&toString;

use base qw(Exporter T2t::BaseClass);
our @EXPORT_OK  = qw(getDataContent);

sub new
{
    my $package = shift;
    my $self    = {};

    $self->{filePath} = shift;

    if( ! $self->{filePath} )
    {
    	$self->{filePath} = getResourceFilePath('.t2trc','t2t.rc');
    }

    $self->{general}  = "";
    $self->{body}     = "";
    $self->{table}    = "";
    $self->{cell}     = "";

    bless( $self, $package );

	message("Using " . $self->{filePath} . " as the initialization file\n");

	if( $self->{filePath} && -e $self->{filePath} )
	{
	    $self->readFile();
	}
	else
	{
		warnMessage( "Missing resource file " . $self->{filePath} . "\n" );
	}

    return $self;
}

sub getSection
{
    my $self    = shift;
    my $section = shift;

    return $self->{$section};
}

sub getPreference
{
    my $self       = shift;
    my $section    = shift;
    my $preference = shift;

    return "" if( ! $section || ! $preference );

    my $completeSection = $self->getSection($section);

    return "" if( ! $completeSection );

    return getDataContent($completeSection, $preference);
}

sub getHighlightColumnNumber()
{
    my $self = shift;

 	my $highlightColumnSection = getDataContent( $self->{table}, "highlightColumn" );

	return undef if( ! $highlightColumnSection );

	return getDataContent( $highlightColumnSection, "number" );
}

sub getHighlightColumnColor()
{
    my $self = shift;

 	my $highlightColumnSection = getDataContent( $self->{table}, "highlightColumn" );

	return undef if( ! $highlightColumnSection );

	return getDataContent( $highlightColumnSection, "color" );
}

sub toString
{
    my $self  = shift;
    return $self->{filePath};
}

sub readFile
{
	my $self = shift;

	my $RC_FILE;
	if( ! open($RC_FILE,'<',$self->{filePath}) )
	{
		warnMessage( "Cannot read resource file", $self->{filePath}, "\n" );
		return;
	}

	local $/ = undef;
	local $_ = <$RC_FILE>;	# slurp in the whole file
	close $RC_FILE;

	s/\n/ /gsx;                     # change newlines to single spaces
	s/<!--.*?->//gsx;				# strip XML comments
	s/<!DOCTYPE \W+ [.*?]>//gsx;	# strip embedded DTD
	s/  */ /g;						# change two or more spaces into one

	$self->{general} = getDataContent($_,"general");
	$self->{body}    = getDataContent($_,"body"   );
	$self->{table}   = getDataContent($_,"table"  );
	$self->{cell}    = getDataContent($_,"cell"   );
}

sub getDataContent
{
	my $completeText = shift;
	my $tag          = shift;

	if( $completeText =~ m!(<$tag>)(.*?)(</$tag>)!s )
	{
		my $value = trim($2);

		return '1' if( $value =~ /^(true|on|yes)$/i  );
		return '0' if( $value =~ /^(false|off|no)$/i );

		return $value;
	}
	else
	{
		return undef;
	}
}

sub getPreferenceOrFileData
{
	my $pref = shift;

	return "" if( ! $pref );

    my $ret = "";

    if( -e $pref )
    {
	    local $/ = undef;
	    open(my $STYLE,'<',$pref) || return "";
	    $ret = <$STYLE>;	                           # slurp in the whole file
	    close $STYLE;
    }
    else
    {
        $ret = getTab() . "$pref\n";
    }

    $ret;
}


1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details
