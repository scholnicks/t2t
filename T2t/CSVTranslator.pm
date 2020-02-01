package T2t::CSVTranslator;

use strict;
use warnings;

use T2t::UserPreferencesCache;
use T2t::Utilities;
use T2t::Translator;
use Data::Dumper;
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

	eval 'use Text::CSV_XS';
	if( $@ )
	{
		warnMessage("Unable to process $file, Text::CSV_XS must be installed.\n");
		return;
	}

  	# create and initialize the table object
  	my $table = $self->createTable();

	open(my $IN,'<',$file) || dieMessage "Cannot open input : $file\n";

	my $csvParser = Text::CSV_XS->new();
  	while( <$IN> )
  	{
  		chomp;

  		$csvParser->parse($_);
  		my @cellData = $csvParser->fields();
  		next if ! @cellData;

		$table->addRow( new T2t::Row(\@cellData) );
	}

  	close $IN;

  	return [$table];
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details
