package T2t::Cell;

use strict;
use warnings;

use T2t::Utilities;
use T2t::UserPreferencesCache;

use overload 
    q{""} => \&toString,
    cmp   => \&compareAsString;
    
use base qw( T2t::HTMLElement );

sub new
{
    my $package = shift;
    
    bless {
       _data     => shift,
       type      => "td",
       attrs     => T2t::UserPreferencesCache::getInstance()->getCellAttributes(),
       emptyRow  => shift || 0
    }, $package;
}

sub toString
{
   my $self  = shift;
   my $prefs = T2t::UserPreferencesCache::getInstance();
   my $addNL = $prefs->setAddNewLineToCell();
   
   if( $self->isEmptyRow() )
   {
        my $s = "<td " . $prefs->getEmptyRowCellAtts() . ">&nbsp;</td>";
        $s .= "\n" if( $addNL );
        
        return $s;
   }
   
   if( ! $self->getData() && $self->getData() ne '0' && $prefs->isNbsp() )
   {
   		return $self->createTag( $self->{type},$self->{attrs},'&nbsp;',$addNL ); 
   }
   
   $self->createTag($self->{type},$self->{attrs}, $self->{_data},$addNL);
}

sub compareAsString
{
   my ($self,$other) = @_;
   $self->{_data} cmp $other;
}

# getXXX() and setXXX() methods...

sub setEmptyRow { $_[0]->{emptyRow} = $_[1]; }
sub isEmptyRow  { return $_[0]->{emptyRow};  }

sub getNoWrap           # nowrap is an empty attribute, so it is special
{                       # returns a boolean 
   defined( $_[0]->{nowrap} ) ? 1 : 0;
}

sub setNoWrap           # nowrap is an empty attribute, so it is special
{
    my ($self,$value) = @_;
    my %attrs         = %{ $self->{attrs} };

    if( $value )
    {  
       $attrs{nowrap} = $T2t::HTMLElement::EMPTY_ATTRIBUTE;
    }
    else
    {
       $attrs{nowrap} = undef;
    }
    $self->{attrs} = { %attrs };
}

sub setHeader
{
    my $self     = shift;
    my $isHeader = shift;
    
    $self->{type} = $isHeader ? "th" : "td";
}

sub isHeader
{
    my $self = shift;
    $self->{type} eq "th";
}

sub setData     {  $_[0]->{_data} = $_[1]; }
sub getData     {  $_[0]->{_data}; }

# HTML attributes

sub setAbbr    {  $_[0]->setIndividualAttribute("abbr",$_[1]); }
sub getAbbr    {  $_[0]->getIndividualAttribute("abbr"); }

sub setAlign    {  $_[0]->setIndividualAttribute("align",$_[1]); }
sub getAlign    {  $_[0]->getIndividualAttribute("align"); }

sub setAxis    {  $_[0]->setIndividualAttribute("axis",$_[1]); }
sub getAxis    {  $_[0]->getIndividualAttribute("axis"); }

sub setColSpan    {  $_[0]->setIndividualAttribute("colspan",$_[1]); }
sub getColSpan    {  $_[0]->getIndividualAttribute("colspan"); }

sub setHeaders    {  $_[0]->setIndividualAttribute("headers",$_[1]); }
sub getHeaders    {  $_[0]->getIndividualAttribute("headers"); }

sub setHeight    {  $_[0]->setIndividualAttribute("height",$_[1]); }
sub getHeight    {  $_[0]->getIndividualAttribute("height"); }

sub setRowSpan    {  $_[0]->setIndividualAttribute("rowspan",$_[1]); }
sub getRowSpan    {  $_[0]->getIndividualAttribute("rowspan"); }

sub setScope    {  $_[0]->setIndividualAttribute("scope",$_[1]); }
sub getScope    {  $_[0]->getIndividualAttribute("scope"); }

sub setWidth    {  $_[0]->setIndividualAttribute("width",$_[1]); }
sub getWidth    {  $_[0]->getIndividualAttribute("width"); }

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
