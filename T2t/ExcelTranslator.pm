package T2t::ExcelTranslator;

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

	eval 'use Spreadsheet::ParseExcel';
	if( $@ )
	{
		warnMessage("Unable to process $file, Spreadsheet::ParseExcel must be installed.\n");
		return;
	}

	eval 'use Spreadsheet::ParseExcel::Workbook';

	my @tables;

	my $excel = Spreadsheet::ParseExcel::Workbook->Parse($file);

  	# create and initialize the table object
  	my $table = $self->createTable();

	foreach my $sheet (@{$excel->{Worksheet}})
	{
		$sheet->{MaxRow} ||= $sheet->{MinRow};

		next if ! $sheet->{MaxRow};

		foreach my $row ($sheet->{MinRow} .. $sheet->{MaxRow})
		{
			my @cellData = ();

			$sheet->{MaxCol} ||= $sheet->{MinCol};
			foreach my $col ($sheet->{MinCol} ..  $sheet->{MaxCol})
			{
				my $cell = $sheet->{Cells}[$row][$col];
				push( @cellData, $cell->{Val}) if( $cell );
			}

			$table->addRow( new T2t::Row(\@cellData) );
		}
	}

	return [$table];
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details
