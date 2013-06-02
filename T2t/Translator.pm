package T2t::Translator;

use strict;
use warnings;

use Cwd;

use T2t::BaseClass;
use T2t::Table;
use T2t::UserPreferencesCache;
use T2t::Utilities;
use T2t::TemplateProcessor;
use T2t::TemplateFactory;

use overload q{""} => \&toString;

use base qw(T2t::BaseClass);

sub new
{
    my $package = shift;
    my $self    = {};
    
    $self->{file} = shift;
    
    bless( $self, $package );
}

sub translate
{
	my $self  = shift;
	my $file  = $self->getFile();		# input filename
	my $prefs = $self->getPreferencesCache();

    my $out  = ">&STDOUT";	# default to stdout

	if( $file )
	{
		$out  = $self->getOutFilename();

		if( ! $prefs->isOverwrite() && -e $out )
		{
			warnMessage("Not overwriting file $out\n");
			return;
		}
		
	    open(STDIN,$file) or dieMessage "Cannot open input : $file\n";
  	}
 
	open(OUT,">$out") or dieMessage "Cannot open output : $out\n";

	my $title = $self->getPreferencesCache()->getTitle() || "";
	
	my $data = "";
	foreach my $table ( @{$self->createData()})
	{
		$data .= $table->toString();
	}
	
	my $processor = new T2t::TemplateProcessor(getTemplate(),$title);
	print OUT $processor->process($data);
	
	close OUT;

	close STDIN if $file;
}

##
#	returns the output filepath
#   @param file		file to be translated
##
sub getOutFilename
{
	my $self = shift;
	
	my $out = $self->getFile();
	my $ri  = rindex($self->getFile(),".");

	if( $ri > -1 ) 
	{
		my $exten = substr($self->getFile(),$ri);   # get the extension
		$out =~ s/$exten/.html/;         			# replace the extension
	}
	else
	{
	   	$out = "$out.html";
	}
	
	$out;
}

##
#	creates the tables from the input
#   @param file		file to be translated
##
sub createData				# creates the tables and outputs them
{
	die "Must override";
}

##
#	creates a Table object
##
sub createTable
{
	return new T2t::Table();
}

sub toString
{
	my $self = shift;
	
	return ref($self) . " : " . ( $self->getFile() ? $self->getFile() : "stdin" ); 
}

sub setFile		{  $_[0]->{file} = $_[1]; }
sub getFile 	{  $_[0]->{file}; }

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
