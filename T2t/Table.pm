package T2t::Table;

use strict;
use warnings;

use Carp;
use T2t::Cell;
use T2t::Row;
use T2t::UserPreferencesCache;
use T2t::CellVisitor;
use T2t::Utilities;

use base qw( T2t::HTMLElement );

sub new
{
    my $package  = shift;
    my $self     = {};

    $self->{delim}       = T2t::UserPreferencesCache::getInstance()->getDelimiter();
    $self->{caption}     = "";
    $self->{attrs}       = T2t::UserPreferencesCache::getInstance()->getTableAttributes();
    $self->{cellVisitor} = new T2t::CellVisitor();
    
    $self->{preLines}    = '';
    $self->{postLines}   = '';
    
    bless( $self, $package );
    
    $self->setIndividualAttribute("summary","t2t table");		# add the required summary attribute
    
    return $self;
}

sub toString
{
   my $self = shift;
   
   dieMessage("No data found\n") if $self->isEmpty();
   
   my $result = '';
   
   $result .= $self->{preLines} if $self->{preLines};
   
   return $result if ! $self->{_data};

   # apply the squeezing, cell widths everytime before we print
   # this gives the calling method the chance to set these attributes before
   # they set the data, or use the same characteristics for multiple sets of data.
   $self->_applyLedger();
   
   my $preferencesCache = T2t::UserPreferencesCache::getInstance();
   
   # XHTML does not allow a table within a paragraph
   # so we use div instead to achieve the same effect
   
   $result .= qq(<div style="margin-top:5px;margin-bottom:5px">\n) if( $preferencesCache->isAddSpace() );
   
   $result .= $self->createTag("table", $self->{attrs}) . "\n";
   
   if( defined($self->{caption}) && $self->{caption} ne "" ) 
   {
       $result .= $self->getTab() . "<caption>$self->{caption}</caption>\n\n";
   }
   
   if( $preferencesCache->isEqualColumns() || $preferencesCache->isLimitSet() )
   {
   	   my $maxColumnCount = -1;
   	   
   	   if( $preferencesCache->isLimitSet() )
   	   {
   	   	   $maxColumnCount = $preferencesCache->getLimit();
   	   }
   	   else
   	   {
		   foreach my $row ( @{$self->{_data}} ) 
		   {
				my $columnCount = $row->getColumnCount();
				if( $columnCount > $maxColumnCount )
				{
					$maxColumnCount = $columnCount;
				}
		   }
   	   }
	   
	   foreach my $row ( @{$self->{_data}} ) 
	   {
	   		$row->limitColumns( $maxColumnCount );
	   }
   }

   if( scalar(@{$self->{_data}}) > 0 )
   {   
       $self->{_data}->[0]->setHeader( $preferencesCache->isHeader() );
   }
   
   $self->setColumnCountForRows();
   
   foreach my $row ( @{$self->{_data}} ) 
   {
        $self->getCellVisitor()->affectRow( $row );
        
        $result .= $self->getTab();
        $result .= $row;
   }

   $result .= "</table>";
   $result .= "\n</div>" if( $preferencesCache->isAddSpace() );
   $result .= "\n";
   
   $result .= $self->{postLines} if $self->{postLines};

   $result;
}

sub addNonDataLines
{
	my $self = shift;
	my $text = shift;
	
	return if ! $text;

	$text = trim($text);
	return if ! $text;
	
	debug("Adding non-blank line: $text");
	
	if ($self->{_data})
	{
		$self->{postLines} .= "$text<br />\n";
	}
	else
	{
		$self->{preLines} .= "$text<br />\n";
	}
}

sub isEmpty
{
	my $self = shift;
	
	return ! $self->{_data} && ! $self->{preLines} && ! $self->{postLines};
}

sub setColumnCountForRows
{
	my $self = shift;

   my $columnCount = 0;
   my $foundEmpty  = 0;
   
   foreach my $row ( @{$self->{_data}} ) 
   {
   	   $columnCount = $row->getColumnCount();
   	   
   	   $foundEmpty = 1 if $row->isEmpty();
   }
   
   if( $foundEmpty )
   {
	   foreach my $row ( @{$self->{_data}} ) 
	   {
	   	   if( $row->isEmpty() )
	   	   {
	   	   	   $row->setNumberOfColumns($columnCount);
	   	   }
	   }
   }
}

sub _applyLedger
{
   my $self = shift;
   my $colors = T2t::UserPreferencesCache::getInstance()->getAllLedgerColors();
   
   return if scalar(@{$colors}) == 0;
   
   # since the first row is not colored for a header
   # we have to move the startimg row to 1
   # also this will keep the color index in synch
   # the first row of data will always have the first
   # color

   my $start = T2t::UserPreferencesCache::getInstance()->isHeader() ? 1 : 0;
  
   for(my $i = $start; $i < scalar(@{$self->{_data}}); $i++)
   {
      my $row = $self->{_data}->[$i];
      $row->setBGColor( $colors->[ ($i-$start) % scalar(@{$colors}) ] );
   }
}

sub removeLedger
{
   my $self = shift;
      
   foreach my $row ( @{$self->{_data}} )
   {
      $row->setBGColor( undef );
   }
}

sub getData {  @{$_[0]->{_data}};  }

sub getNumberOfRows
{
	my $self = shift;
	return scalar(@{$self->{_data}});
}

sub getRow
{
    my ($self,$index) = @_;
    @{$self->{_data}}[$index];
}

sub setRow
{
    my ($self,$index, $row) = @_;
    $self->{_data}->[$index] = $row;
}

sub addRow
{
    my ($self, $row) = @_;
    push(@{$self->{_data}}, $row);
}

sub getCaption() { $_[0]->{caption}; }
sub setCaption() { $_[0]->{caption} = $_[1]; }

sub getDelimiter() { $_[0]->{delim}; }
sub setDelimiter() { $_[0]->{delim} = $_[1]; }

sub setDataPageSize    {  $_[0]->setIndividualAttribute("datapagesize",$_[1]); }
sub getDataPageSize    {  $_[0]->getIndividualAttribute("datapagesize"); }

sub getCellVisitor { $_[0]->{cellVisitor}; }
sub setCellVisitor
{
    my $self = shift;
    my $visitor = shift;
    
    $self->{cellVisitor} = defined $visitor ? $visitor : new T2t::CellVisitor();
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
