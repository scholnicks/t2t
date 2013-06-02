package T2t::TextFileTranslator;

use strict;
use warnings;

use T2t::Row;
use T2t::EmptyRow;
use T2t::UserPreferencesCache;
use T2t::Utilities;
use T2t::Translator;

use base qw(T2t::Translator);

sub new
{
    my $package  = shift;
    bless( {}, $package );
}

##
#	creates the tables from the input
#   @param file		file to be translated
##
sub createData				# creates the tables and outputs them
{
	my $self  = shift;
	my $file  = $self->getFile();		# input filename
	my $prefs = $self->getPreferencesCache();

	if ($file)
	{
	    open(STDIN,$file) or dieMessage "Cannot open input : $file\n";
  	}
 
	my @tables;
	
	# create an easy reference to the delimiter
  	my $delim = $prefs->getDelimiter();
   
  	# create and initialize the table object
  	my $table = $self->createTable();

  	my @data;
  	while( <STDIN> )
  	{
    	chomp;
    	next if( $prefs->isDashes() && /-----|_____/ );
    	push(@data,$_);
    }
  	close( STDIN );

  	for (my $i=0; $i < scalar(@data); $i++)
  	{
  		local $_ = $data[$i];
  		
     	s/  */ /g;		# 2 or more spaces to one
     
     	if( $prefs->isSqueeze() )
     	{
     		s/$delim$delim*/$delim/g;
     		chop if( /$delim$/ );				# handle a line with a final delimiter
     	}

		$_ = '' if( /^$delim*$/ );

     	if( /$delim/ )
     	{
			my @cellData = split($delim, $_);
			$table->addRow( new T2t::Row(\@cellData) );
     	}
     	else
     	{
        	if( $prefs->isOneTable() )  		# just one table, just add a blank line
        	{
        		next if ($prefs->isSqueeze() && /^$/);
        		
				$table->addRow( new T2t::EmptyRow() );
        	}
        	else 								# dump the line to the output
        	{
				$table->addNonDataLines($_);
				
				if ( ($i+1) < scalar(@data) && $data[$i+1] =~ /$delim/ )
				{
					push(@tables,$table);
					$table = $self->createTable();	# create a new table
				}
        	}
     	}
  	}
 
	push(@tables,$table); # if ! $table->isEmpty();
	return \@tables;
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
