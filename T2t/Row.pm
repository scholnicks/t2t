package T2t::Row;

use strict;
use warnings;

use T2t::Cell;
use T2t::UserPreferencesCache;
use T2t::Utilities;

use overload q{""} => \&toString;

use base qw( T2t::HTMLElement );

sub new
{
    my $package = shift;
    my $self    = {};

    my $dataRef          = shift;
    $self->{header}      = shift || 0;
    $self->{attrs}       = T2t::UserPreferencesCache::getInstance()->getRowAttributes();

    bless( $self, $package );

    $self->{_data} = $self->_createCells($dataRef);
    
    $self;
}

sub _createCells
{
   my ($self,$dataRef) = @_;
   my @cells = ();
   
   my $limit = T2t::UserPreferencesCache::getInstance()->getLimit();
   
   my $dataCount = $limit > 0 ? $limit : scalar(@$dataRef);
   
   for (my $i=0; $i < $dataCount; $i++)
   {
      push( @cells, new T2t::Cell($dataRef->[$i],$self->{header}) );
   }
   
   return \@cells;
}

sub limitColumns
{
	my $self           = shift;
	my $newColumnCount = shift;
	
	my $currentColumnCount = $self->getColumnCount();

	return if( $newColumnCount == $currentColumnCount );
	
	if( $newColumnCount > $currentColumnCount )					# add new padding columns
	{
		for( my $i=0; $i < ($newColumnCount - $currentColumnCount); $i++ )
		{
			push( @{$self->{_data}}, new T2t::Cell() );
		}
	}
	else														# remove columns
	{
		splice( @{$self->{_data}}, $newColumnCount );
	
	}
}

sub getColumnCount
{
    my $self = shift;
    return scalar(@{$self->{_data}});
}

sub setCellAttributes
{
   my ($self,%items) = @_;
   foreach my $cell ( @{$self->{_data}} )
   {
      $cell->setAllAttributes( %items );
   }
}

sub getCell
{ 
   my $self  = shift;
   my $index = shift;
   return $self->{_data}->[$index];
}

sub setCellType
{
   my ($self,$type) = @_;
   foreach my $cell ( @{$self->{_data}} ) 
   {
        $cell->setType( $type );
   }   
}

sub toString
{
   my $self   = shift;
   
   my $skipField = T2t::UserPreferencesCache::getInstance()->getSkipFields();
   
   my $result = "";
   
   $result .= "<thead>" if( $self->isHeader() );
   $result .= $self->createTag("tr", $self->{attrs});
   
   my $i = 0;

   foreach my $cell ( @{$self->{_data}} ) 
   {
       	if( $skipField && ($i+1) =~ /$skipField/ )
       	{
       		# print STDERR "skipping column " . ($i+1) . "\n";
        	$i++;
        	next;       
       	}
        
        if( $self->isHeader() )
        {
        	if( ($i+1) == T2t::UserPreferencesCache::getInstance()->getHighlightColumnNumber() )
        	{
        		$cell->setBGColor( T2t::UserPreferencesCache::getInstance()->getHighlightColumnColor() );
        	}
        }
        
		$cell->setHeader( $self->isHeader() );
	  
		$result .= $self->getTab();
		$result .= $self->getTab();
		 
		$cell->setAlign( T2t::UserPreferencesCache::getInstance()->getCellAlignment($i) );
		$cell->setWidth( T2t::UserPreferencesCache::getInstance()->getCellWidth($i) );
		 
		$result .= $cell;
       
       	$i++;
   }

   $result .= $self->getTab();
   $result .= "</tr>";
   $result .= "</thead>" if( $self->isHeader() );
   $result .= "\n";

   $result;
}

sub isEmpty { return 0; }

sub setHeader   {  $_[0]->{header} = $_[1]; }
sub isHeader    {  $_[0]->{header};         }

sub setTitle    {  $_[0]->setIndividualAttribute("title",$_[1]); }
sub getTitle    {  $_[0]->getIndividualAttribute("title"); }

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
