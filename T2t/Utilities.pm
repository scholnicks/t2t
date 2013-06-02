package T2t::Utilities;

require Exporter;

use strict;
use warnings;

use T2t::UserPreferencesCache;

use base qw(Exporter);

our @EXPORT = qw(trim cleanArguments getPath getResourceFilePath printFile getFileData
                 getFileAsArray message warnMessage dieMessage debug expandPath);

sub getFileData
{
	my $filePath = shift;
	
	return "" if( ! $filePath );
	
	$filePath = expandPath( $filePath );
	
    my $ret = "";
    
    debug("Reading in $filePath");
    
    if( -e $filePath )
    {
	    local $/ = undef;
	    open(my $STYLE,"<",$filePath) || return "";
	    $ret = <$STYLE>;	                           # slurp in the whole file
	    close $STYLE;
    }
    
    $ret;
}

sub expandPath
{
	my $path = shift;
	
	return $path if $path !~ /^~/;
	
	my $home = $ENV{"HOME"};
	
	warnMessage( "HOME is not set" ) if ! $home;
	
	$path =~ s/~/$home/;
	
	$path;
}

#	returns the RC file path
sub getResourceFilePath
{
	my $unixStyle  = shift;						# unix rc file naming, eg .t2trc
	my $otherStyle = shift; 					# win rc file, eg t2t.rc

	warnMessage( "HOME is not set" ) if ! $ENV{"HOME"};
	
  	# first try unix style
  	my $initPath = getPath($ENV{"HOME"},$unixStyle);
  
  	# if not there, try others style
  	$initPath = getPath($ENV{"HOME"},$otherStyle) if( ! -e $initPath );
  
 	if( -e $initPath )
  	{
  		return $initPath;
    }
    else
    {
     	return;
    }
}

sub getFileAsArray			# returns a whole file as an array text lines
{
	my $file = shift;
	
	my @lines;

	open(my $IN,"<",$file) || return @lines;
	while( <$IN> )
	{
		chomp;
		next if /^$/;
		push(@lines,$_);
	}
	close $	IN;
	
	@lines;
}

sub trim  # trims whitespace
{
    local $_ = shift;
    s/^\s+//;
    s/\s+$//;
    $_;
}

sub printFile    # prints a file verbatim to the specified file handle
{
   my $file = shift || return;
   my $FH   = shift || return;
   
   open(my $INP,"<",$file) || return;
   print $FH $_ while( <$INP> );
   close $INP;
}

sub getPath   # returns a full path
{
   my $dir      = shift;
   my $filename = shift;

   if( $filename =~ m!^/! )     # check for a fully-qualified path
   {
       return $filename;
   }

   return "$dir/$filename";
}

sub cleanArguments
{
	my @args = @_;
	foreach ( @args )
	{
		$_ = '' if( ! $_ );
	}
	
	return @args;
}

sub debug
{
	return if isQuiet() || ! isDebug();

	print STDERR 't2t (DEBUG) :: ' . join(' ',cleanArguments(@_)) . "\n";
}

sub message
{
	return if isQuiet() || ! isVerbose();

	print STDOUT 't2t : ' . join(' ',cleanArguments(@_));
}

sub warnMessage
{
	return if isQuiet();

	print STDERR 't2t : ' . join(' ',cleanArguments(@_));
}

sub dieMessage
{
	print STDERR 't2t : ' . join(' ',cleanArguments(@_));
	exit -1;
}

sub isQuiet	
{
    return T2t::UserPreferencesCache::getInstance()->isQuiet();
}

sub isVerbose	
{
    return T2t::UserPreferencesCache::getInstance()->isVerbose() || isDebug();
}

sub isDebug	
{
    return T2t::UserPreferencesCache::getInstance()->isDebug();
}


1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
