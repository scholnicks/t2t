package T2t::UserPreferencesCache;

use strict;
use warnings;

use T2t::Utilities;

our $instance = undef;

sub _new
{
    my $package  = shift;
    my $self   = {};
    
    $self->{skipFields}       			= 'zz';
    $self->{header}           			= 0;
    $self->{debug}           			= 0;
    $self->{emptyRowCellAtts} 			= "";
    $self->{quiet}            			= 0;
    $self->{verbose}           			= 0;
    $self->{overwrite}         			= 1;
    $self->{addNewLineToCell} 			= 0;
    $self->{nbsp}			  			= 0;
    $self->{xhtml}						= 0;
    $self->{addSpace}	  				= 0;
    $self->{limit}			  			= -1;		# no limit by default
    $self->{'highlightColumn.color'} 	= '';
    $self->{'highlightColumn.number'} 	= '';
    $self->{removeEmptyRows}            = 0;
    $self->{templateFile}               = undef;
    
    $self->{ledgerColors}   = [];
    $self->{cellAlignments} = [];
    $self->{cellWidths}     = [];
    
    $self->{cellAtts}  = {};
    $self->{tableAtts} = {};
    $self->{rowAtts}   = {};
    $self->{bodyAtts}  = {};
    
    bless( $self, $package );
}

sub getInstance
{
    $instance = _new T2t::UserPreferencesCache() if ! defined $instance;
    $instance;
}

sub parseAttributes
{
    my $self  = shift;
    my $prefs = shift;
    
    foreach my $key ( sort keys %{$prefs} )
    {
        $self->saveOption($prefs, $key );
    }
    
    # for all of these options, only set them if a value is being passed in
    
    $self->setTemplateFile(     $prefs->{'general.template'}        ) if defined $prefs->{'general.template'};
    $self->setDelimiter(        $prefs->{'general.delim'}           ) if defined $prefs->{'general.delim'};
	$self->setDebug( 			$prefs->{'general.debug'} 			) if defined $prefs->{'general.debug'};
	$self->setQuiet( 			$prefs->{'general.quiet'} 			) if defined $prefs->{'general.quiet'};
	$self->setVerbose( 			$prefs->{'general.verbose'}			) if defined $prefs->{'general.verbose'};
	$self->setOverwrite( 		$prefs->{'general.overwrite'}       ) if defined $prefs->{'general.overwrite'};
	$self->setSkipFields( 		$prefs->{'general.skipFields'} 		) if defined $prefs->{'general.skipFields'};
	$self->setAddNewLineToCell( $prefs->{'general.addNewLine'} 		) if defined $prefs->{'general.addNewLine'};
	$self->setNbsp( 			$prefs->{'general.nbsp'} 			) if defined $prefs->{'general.nbsp'};
	$self->setHeader(  			$prefs->{'general.header'}  		) if defined $prefs->{'general.header'};
	$self->setEmptyRowCellAtts( $prefs->{'general.emptyRowCellAtt'}	) if defined $prefs->{'general.emptyRowCellAtt'};
	$self->setAddSpace(			$prefs->{'general.addSpace'}		) if defined $prefs->{'general.addSpace'};
	$self->setLimit(            $prefs->{'general.limit'}           ) if defined $prefs->{'general.limit'};
	
	$self->setTablesOnly(		$prefs->{'general.tablesOnly'}		) if defined $prefs->{'general.tablesOnly'};
	$self->setDashes(			$prefs->{'general.dashes'}			) if defined $prefs->{'general.dashes'};
	$self->setSqueeze(			$prefs->{'general.squeeze'}			) if defined $prefs->{'general.squeeze'};
	$self->setOneTable(			$prefs->{'general.oneTable'}		) if defined $prefs->{'general.oneTable'};
	$self->setTitle(			$prefs->{'general.title'}			) if defined $prefs->{'general.title'};
	$self->setCreateH1(			$prefs->{'general.createH1'}		) if defined $prefs->{'general.createH1'};
	$self->setEqualColumns(		$prefs->{'general.equalColumns'}	) if defined $prefs->{'general.equalColumns'};
	$self->setRemoveEmptyRows(  $prefs->{'general.removeEmptyRows'} ) if defined $prefs->{'general.removeEmptyRow'};

	$self->setLedgerColors(   $prefs->{'table.ledgerColors'}	) if defined $prefs->{'table.ledgerColors'};
	$self->setCellWidths(     $prefs->{'table.cellWidths'} 		) if defined $prefs->{'table.cellWidths'};
	$self->setCellAlignments( $prefs->{'table.cellAlignments'} 	) if defined $prefs->{'table.cellAlignments'};
	
	$self->setHighlightColumnColor(  $prefs->{'table.highlightColumn.color'}  ) if( $prefs->{'table.highlightColumn.color'}  );
	$self->setHighlightColumnNumber( $prefs->{'table.highlightColumn.number'} ) if( $prefs->{'table.highlightColumn.number'} );
}

sub saveOption
{
    my $self       = shift;
    my $attributes = shift;
    my $key        = shift;
    
    local $_  = $key;
    
    s!(.*?)\.!!;
    
    if(  $key =~ /^cell/ )
    {
        $self->{cellAtts}->{$_} = $attributes->{$key};
    }
    elsif(  $key =~ /^table/ )
    {
        $self->{tableAtts}->{$_} = $attributes->{$key};
    }
 }
 
sub getHighlightColumnNumber() 
{  
	my $value = $_[0]->{'highlightColumn.number'}; 
	return $value ? $ value : -1;
}

sub setDelimiter 		
{
	my ($self,$delim) = @_;
	
    $delim = "\t" if ! $delim;
    $delim = "\t" if $delim eq '\t';

	$self->{delimiter} = $delim; 
}

sub getDelimiter    {  $_[0]->{delimiter}; }

sub getTemplateFile { $_[0]->{templateFile} }
sub setTemplateFile { $_[0]->{templateFile} = $_[1]; }

sub isEqualColumns	{ $_[0]->{equalColumns}; }
sub setEqualColumns	{ $_[0]->{equalColumns} = $_[1]; }

sub setTablesOnly 	{  $_[0]->{tablesOnly} = $_[1]; }
sub isTablesOnly	{  $_[0]->{tablesOnly}; }

sub setDashes		{  $_[0]->{dashes} = $_[1]; }
sub isDashes		{  $_[0]->{dashes}; }

sub setSqueeze   	{  $_[0]->{squeeze} = $_[1]; }
sub isSqueeze		{  $_[0]->{squeeze}; }

sub setOneTable   	{  $_[0]->{oneTable} = $_[1]; }
sub isOneTable		{  $_[0]->{oneTable}; }

sub setTitle   		{  $_[0]->{title} = $_[1]; }
sub getTitle		{  $_[0]->{title}; }

sub setCreateH1   	{  $_[0]->{h1} = $_[1]; }
sub isCreateH1		{  $_[0]->{h1}; }

sub setHighlightColumnNumber() {  $_[0]->{'highlightColumn.number'} = $_[1]; }

sub getHighlightColumnColor() {  $_[0]->{'highlightColumn.color'}; }
sub setHighlightColumnColor() {  $_[0]->{'highlightColumn.color'} = $_[1]; }

sub setAddSpace 			{  $_[0]->{addSpace} = $_[1]; }
sub isAddSpace  			{  $_[0]->{addSpace}; }

sub setDebug				{  $_[0]->{debug} = $_[1]; }
sub isDebug  				{  $_[0]->{debug}; }

sub setQuiet 				{  $_[0]->{quiet} = $_[1]; }
sub isQuiet  				{  $_[0]->{quiet}; }

sub setVerbose 				{  $_[0]->{verbose} = $_[1]; }
sub isVerbose  				{  $_[0]->{verbose}; }

sub setOverwrite			{  $_[0]->{overwrite} = $_[1]; }
sub isOverwrite				{  $_[0]->{overwrite}; }

sub isHeader          		{ $_[0]->{header}; }
sub setHeader           	{ $_[0]->{header} = $_[1]; }

sub setLimit        		{  $_[0]->{limit} = $_[1]; }
sub getLimit         		{  $_[0]->{limit}; }

sub isLimitSet
{
	my $self = shift;
	return $self->getLimit() > 0;
}

sub setSkipFields        	{  $_[0]->{skipFields} = $_[1]; }
sub getSkipFields         	{  $_[0]->{skipFields}; }

sub setEmptyRowCellAtts   {  $_[0]->{emptyRowCellAtts} = $_[1]; }

sub getEmptyRowCellAtts   
{
	my $self = shift;  
	return '' if ! $self->{emptyRowCellAtts};
	return $self->{emptyRowCellAtts};
}


sub getAllLedgerColors   { $_[0]->{ledgerColors};      }

sub setLedgerColors
{
    my $self = shift;
    my $text = shift;
    
    return if ! $text;
    
    $self->addLedgerColors( split(',',$text) );  
}

sub addLedgerColors
{
    my $self   = shift;
    my @colors = @_;
    foreach ( @colors )
    {
        push( @{$self->{ledgerColors}}, trim($_) );
    }
}

sub removeLedgerColors
{
    my $self = shift;
    splice @{$self->{ledgerColors}};
}

sub getAllCellWidths   { $_[0]->{cellWidths};      }

sub getCellWidth
{
    my $self = shift;
    my $pos  = shift;
    $self->{cellWidths}->[$pos];
}

sub setCellWidths
{
    my $self = shift;
    my $text = shift;
    
    return if ! $text;
    
    $self->addCellWidths( split(',',$text) );  
}

sub addCellWidths
{
    my $self = shift;
    my @widths = @_;
    foreach ( @widths )
    {
        push(@{$self->{cellWidths}}, trim($_) );
    }
}

sub removeCellWidths
{
    my $self = shift;
    splice @{$self->{cellWidths}};
}

sub getAllCellAlignments   { $_[0]->{cellAlignments};      }

sub getCellAlignment
{
    my $self = shift;
    my $pos  = shift;
    $self->{cellAlignments}->[$pos];
}

sub setCellAlignments
{
    my $self = shift;
    my $text = shift;
    
    return if ! $text;
    
    $self->addCellAlignments( split(',',$text) );  
}

sub addCellAlignments
{
    my $self = shift;
    my @widths = @_;
    foreach ( @widths )
    {
        push(@{$self->{cellAlignments}}, trim($_) );
    }
}

sub removeCellAlignments
{
    my $self = shift;
    splice @{$self->{cellAlignments}};
}

sub setTableAttributes {  $_[0]->{tableAtts} = $_[1]; }

sub getTableAttributes 
{
	my $self           = shift;
	my %localTableAtts = ();
	my %savedAtts      = %{$self->{tableAtts}};
	
	foreach ( keys(%savedAtts) )
	{
		# only return the attibutes that are HTML compliant
		if( ! /cellWidths|cellAlignments|ledgerColors|highlightColumn/ )
		{
			$localTableAtts{$_} = $savedAtts{$_}; 
		}
	}
	
	return \%localTableAtts;
}

sub setNbsp			 	{  $_[0]->{nbsp} = $_[1]; }
sub isNbsp 				{  $_[0]->{nbsp}; }

sub setCellAttributes 	{  $_[0]->{cellAtts} = $_[1]; }
sub getCellAttributes 	{  $_[0]->{cellAtts}; }

sub setRowAttributes 	{  $_[0]->{rowAtts} = $_[1]; }
sub getRowAttributes 	{  $_[0]->{rowAtts}; }

sub setBodyAttributes 	{  $_[0]->{bodyAtts} = $_[1]; }
sub getBodyAttributes 	{  $_[0]->{bodyAtts}; }

sub setAddNewLineToCell	{  $_[0]->{addNewLineToCell} = $_[1]; }
sub getAddNewLineToCell {  $_[0]->{addNewLineToCell}; }

sub setRemoveEmptyRows	{  $_[0]->{removeEmptyRows} = $_[1]; }
sub getRemoveEmptyRows  {  $_[0]->{removeEmptyRows}; }


1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
