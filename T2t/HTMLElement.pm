package T2t::HTMLElement;

use strict;
use warnings;

use T2t::BaseClass;
use T2t::Utilities;

use base qw(T2t::BaseClass);

our @ISA     = qw(Exporter);
our @EXPORT  = qw(getTab);

our $TAB             = "   ";               # tab (4 spaces)
our $EMPTY_ATTRIBUTE = "EMPTY_ATTRIBUTE";   # value for an empty attribute

sub new
{
    my $package = shift;
    bless( {}, $package );
}

sub isEmptyTag
{
   my $self = shift;
   my $tag  = shift;

   return 0 if ! $tag;
      
   $tag eq $EMPTY_ATTRIBUTE;
}

sub getTab
{
   $TAB;
}

# these next 3 methods depend on the fact
# that ALL sub-classes keep their attributes in a hashtable
# called attrs

sub setIndividualAttribute
{
    my ($self,$attName,$value) = @_;
    
    return if ! $value;
    
    my %attrs                  = %{ $self->{attrs} };
    $attrs{$attName}           = $value;
    $self->{attrs}             = { %attrs };
}

sub getIndividualAttribute
{
    my ($self,$attName) = @_;
    my %attrs           = %{ $self->{attrs} };
    $attrs{$attName};
}

sub setAllAttributes
{
   my ($self,%items) = @_;
   my %attrs = %{ $self->{attrs} };
   
   foreach ( keys %items )
   {
       $attrs{$_} = $items{$_};
   }

   $self->{attrs} = { %attrs };
}

sub setBackground    {  $_[0]->setIndividualAttribute("background",$_[1]); }
sub getBackground    {  $_[0]->getIndividualAttribute("background"); }

sub setBGColor    {  $_[0]->setIndividualAttribute("bgcolor",$_[1]); }
sub getBGColor    {  $_[0]->getIndividualAttribute("bgcolor"); }

sub setBorderColor    {  $_[0]->setIndividualAttribute("bordercolor",$_[1]); }
sub getBorderColor    {  $_[0]->getIndividualAttribute("bordercolor"); }

sub setChar    {  $_[0]->setIndividualAttribute("char",$_[1]); }
sub getChar    {  $_[0]->getIndividualAttribute("char"); }

sub setCharOff   {  $_[0]->setIndividualAttribute("charoff",$_[1]); }
sub getCharOff    {  $_[0]->getIndividualAttribute("charoff"); }

sub setClass    {  $_[0]->setIndividualAttribute("class",$_[1]); }
sub getClass    {  $_[0]->getIndividualAttribute("class"); }

sub setDir    {  $_[0]->setIndividualAttribute("dir",$_[1]); }
sub getDir   {  $_[0]->getIndividualAttribute("dir"); }

sub setID    {  $_[0]->setIndividualAttribute("id",$_[1]); }
sub getID    {  $_[0]->getIndividualAttribute("id"); }

sub setLang    {  $_[0]->setIndividualAttribute("lang",$_[1]); }
sub getLang    {  $_[0]->getIndividualAttribute("lang"); }

sub setStyle    {  $_[0]->setIndividualAttribute("style",$_[1]); }
sub getStyle    {  $_[0]->getIndividualAttribute("style"); }

sub setTitle    {  $_[0]->setIndividualAttribute("title",$_[1]); }
sub getTitle    {  $_[0]->getIndividualAttribute("title"); }

sub setVAlign   {  $_[0]->setIndividualAttribute("valign",$_[1]); }
sub getVAlign   {  $_[0]->getIndividualAttribute("valign"); }

sub createTag
{
   my $self         = shift;
   my $type         = shift;
   my $attrRef      = shift;
   my $data         = shift;
   my $addNewLine 	= shift;
   
   $addNewLine = 0 if( ! defined $addNewLine );
   
   my $result   = "<$type";
   foreach ( sort keys(%$attrRef) )
   {
       if( $self->isEmptyTag($attrRef->{$_})  )
       {
           	$result .= " $_";
       }
       else
       {   
       		$result .= " $_=\"$attrRef->{$_}\"" if( defined $attrRef->{$_} && length($attrRef->{$_}) > 0 );
       }
   }
   $result .= ">";
   
   if( defined $data ) 
   {
      $result .= $data;
      $result .= "</$type>";
   }
   $result .= "\n" if( $addNewLine );
   
   $result;
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-2010, Steven Scholnick <steve@scholnick.net>  

t2t is published under LGPL.  See license.html for details
