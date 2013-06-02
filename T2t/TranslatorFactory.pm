package T2t::TranslatorFactory;

use strict;
use warnings;

use T2t::TextFileTranslator;
use T2t::ExcelTranslator;
use T2t::OpenOfficeTranslator;
use T2t::CSVTranslator;
use T2t::Utilities;

our $instance = undef;

sub _new
{
    my $package = shift;
    bless( {}, $package );
}

sub getInstance		# singleton method
{
    $instance = _new T2t::TranslatorFactory() if ! defined $instance;
    return $instance;
}

sub createTranslator
{
	my $self = shift;
	my $file = shift;
	
	my $translator = $self->getTranslator($file);
	$translator->setFile( $file );
	
	debug("Translator =",$translator);
	
	return $translator;
}


sub getTranslator
{
	my $self = shift;
	my $file = shift;

	return new T2t::TextFileTranslator() if ! $file;
	
	return new T2t::ExcelTranslator()      if ( $file =~ /.xls$/ );
	return new T2t::OpenOfficeTranslator() if ( $file =~ /.ods$/ );
	return new T2t::OpenOfficeTranslator() if ( $file =~ /.sxc$/ );
	return new T2t::CSVTranslator()        if ( $file =~ /.csv$/ );
	
	return new T2t::TextFileTranslator();
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
