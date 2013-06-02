package T2t::OpenOfficeTranslator;

use strict;
use warnings;

use T2t::Utilities;
use T2t::Translator;
use T2t::Row;

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
	my $self = shift;
	my $file = $self->getFile();		# input filename
	
	dieMessage "No file specified\n" if( ! $file );

	eval 'use Spreadsheet::ReadSXC qw(read_sxc)';
	if( $@ )
	{
		warnMessage("Unable to process $file, Spreadsheet::ReadSXC must be installed.\n");
		return;
	}

	my @tables;
	
	my $workBook = read_sxc($file);
	
  	# create and initialize the table object
  	my $table = $self->createTable();

	foreach ( sort keys %$workBook ) 
	{
		next if $#{$$workBook{$_}} < 1;

	 	foreach ( @{$$workBook{$_}} ) 					# each row
	 	{
	 		next if ! defined $_;
	 		my @data = @{$_};
	 		
			my @cellData = ();
		
			foreach ( @data ) 
			{
		 		next if ! defined $_;
		   		push( @cellData, $_ );
			}
		
			$table->addRow( new T2t::Row(\@cellData) );
	 	}
	}

	return [$table];
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
