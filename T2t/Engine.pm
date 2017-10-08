package T2t::Engine;

use strict;
use warnings;

use Cwd;

use T2t::BaseClass;
use T2t::Table;
use T2t::Row;
use T2t::Cell;
use T2t::UserPreferencesCache;
use T2t::Utilities;
use T2t::TranslatorFactory;

use base qw(T2t::BaseClass);

sub new
{
    my $package  = shift;
    bless( {}, $package );
}

##
#	creates the table for all incoming arguments
#   @param args		paths to directories or files that will be translated
##
sub processFilesAndDirectories	# does all the work.
{
   my $self          = shift;
   my @args          = @_;
   my $baseDir       = cwd();

   my @dirArguments;
   my @fileArguments;

   foreach my $arg ( @args )
   {
      if( -d $arg )   # found a directory, add it to the dir list
      {
         push(@dirArguments,$arg);
      }
      else            # just a file, add it to the file list
      {
        push(@fileArguments,$arg);
      }
   }

   # translate each of directories one at a time
   foreach my $dir ( @dirArguments )
   {
      $self->translateFileOrDirectory( $dir );
      chdir $baseDir;
   }

   $self->translateFileOrDirectory( @fileArguments );  # process all the files
}

##
#	performs the ASCII -> HTML translation for a single file
#   @param path		file to be translated
##
sub translateFileOrDirectory		# goes through each file in the list
{
  my $self    = shift;
  my @files   = @_;

  if (scalar(@files) == 0)
  {
  	  $self->translate();
  	  return;
  }

  my $cur  = $_[0];

  return if ! $cur;

  message("processing $cur\n");

  my @current;
  my $cwd     = ".";

  if( -d $cur )
  {
     chdir $cur;
     $cwd = cwd();
     message("reading directory $cur\n");

     if( ! opendir(DIR,$cwd) )
     {
     	warnMessage("cannot open directory $cwd for reading: $!");
     	return;
     }

     @current = grep(!/^\.\.?$|\.html?$/, readdir(DIR));  # elim .,.., & .html
     closedir(DIR);
  }
  else
  {
     push(@current,@_);		# add the WHOLE array of files to current
  }

  foreach my $file ( @current )
  {
     if( -d $file )					# a directory
     {
        message("reading directory $file\n");
        $self->translateFileOrDirectory( ($file) );				# recursively through files
        chdir('..');
     }
     else					# a text file
     {
        my $path = getPath(cwd(),$file);
        message("processing file $path\n");
        $self->translate($file);
     }
  }
}

##
#	creates the tables from the input
#   @param file		file to be translated
##
sub translate				# creates the tables and outputs them
{
	my $self = shift;
	my $file = shift;		# input filename

	T2t::TranslatorFactory::getInstance()->createTranslator($file)->translate();
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.html for details
