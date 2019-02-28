#!/usr/bin/perl
#
#  t2t:	text to table translator
#
#  (c) Steven Scholnick <scholnicks@gmail.com>
#
#  t2t is published under a MIT license. See https://scholnick.net/license.txt for details.
#
#  Full documentation avaiable at:
#	https://scholnick.net/t2t
#
###############################################################################################

use strict;
use warnings;

use Cwd;
use Getopt::Long;

use lib '/Users/steve/perl/t2t';

use T2t::Engine;
use T2t::PreferencesFileReader;
use T2t::Utilities;
use T2t::UserPreferencesCache;

our $version = '7.3.2';

{
	my $initFilePath;
	my %commandLine;		# holds only the user specified command line options
	my %prefs;				# all of the preferences

	GetOptions
	(
		'class=s'           => \$commandLine{'table.class'},
		'dashes!'			=> \$commandLine{'general.dashes'},
		'debug!'			=> \$commandLine{'general.debug'},
		'delim=s'			=> \$commandLine{'general.delim'},
		'header!'      		=> \$commandLine{'general.header'},
		'equal!'			=> \$commandLine{'general.equalColumns'},
		'help'      		=> \&help,
		'highlight=s'		=> \$commandLine{'table.highlightColumn.number'},
		'html5!'            => \$commandLine{'general.html5'},
		'id=s'              => \$commandLine{'table.id'},
		'initFilePath=s'	=> \$initFilePath,
		'limit=s'			=> \$commandLine{'general.limit'},
		'nbsp!'				=> \$commandLine{'general.nbsp'},
		'one!'		        => \$commandLine{'general.oneTable'},
		'overwrite!'		=> \$commandLine{'general.overwrite'},
		'quiet!'			=> \$commandLine{'general.quiet'},
		'squeeze!'			=> \$commandLine{'general.squeeze'},
		'skipfields=s'		=> \$commandLine{'general.skipFields'},
		'style=s'           => \$commandLine{'table.style'},
		'tablesOnly!'		=> \$commandLine{'general.tablesOnly'},
		'template=s'		=> \$commandLine{'general.template'},
		'title=s'			=> \$commandLine{'general.title'},
		'verbose!'			=> \$commandLine{'general.verbose'},
		'version'   		=> \&version,
		'wholeTable!'		=> \$commandLine{'general.oneTable'},
	) or help();

	$commandLine{'general.template'} = 't2t-internal-html5' if $commandLine{'general.html5'};

	# first process command line options so --initFilePath and --quiet will be used
	T2t::UserPreferencesCache::getInstance->parseAttributes( \%commandLine );

	# command the command line and the prefs file into one set
	merge( $initFilePath, \%commandLine, \%prefs );

	$prefs{'general.template'} = 't2t-internal-html5' if $prefs{'general.html5'};

	# now process all of the options for all data processing
	T2t::UserPreferencesCache::getInstance->parseAttributes( \%prefs );

	# do the real work
	new T2t::Engine()->processFilesAndDirectories( @ARGV );

	exit 0;
}

#################  end of main  #####################

sub merge	# reads from the preferences and adds all of the prefs to the prefs
{			# hash table

	my $initFilePath 	= shift;
	my $lineSpecified 	= shift;
	my $prefs         	= shift;

	my $prefsReader = new T2t::PreferencesFileReader( $initFilePath );

	foreach ( qw(delim title skipFields header quiet squeeze verbose overwrite debug html5
				 oneTable emptyRowCellAtt nbsp limit tablesOnly addSpace equalColumns)
		    )
	{
		my $prefName = "general.$_";

		$prefs->{$prefName} = $prefsReader->getPreference('general',$_);

		# if the preference is specified on the command line
		# use the command line version always

		if( defined($lineSpecified->{$prefName}) )
		{
			$prefs->{$prefName} = $lineSpecified->{$prefName};
		}
	}

	foreach ( qw(style id class border width cellspacing cellpadding bgcolor align emptyRowCellAtt cellAlignments cellWidths ledgerColors) )
	{
		my $prefName = "table.$_";

		$prefs->{$prefName} = $prefsReader->getPreference('table',$_);
		$prefs->{$prefName} = $lineSpecified->{$prefName} if defined($lineSpecified->{$prefName});
	}

	foreach ( qw(bgcolor headerColor) )
	{
		$prefs->{"cell.$_"} = $prefsReader->getPreference('cell',$_);
	}

	# handle highlight column attributes separately

	$prefs->{'table.highlightColumn.number'} = $prefsReader->getHighlightColumnNumber();
	$prefs->{'table.highlightColumn.color'}  = $prefsReader->getHighlightColumnColor();

	# check for the the highlight column number on the command line
	if( defined($lineSpecified->{'table.highlightColumn.number'}) )
	{
		# make sure that we have a color if not whine and no highlighting
		if( defined($prefs->{'table.highlightColumn.color'}) )
		{
			$prefs->{'table.highlightColumn.number'} = $lineSpecified->{'table.highlightColumn.number'};
		}
		else
		{
			warnMessage("Highlight column specified on command line but no color defined in the .t2trc file.  Skipping.\n");
			$prefs->{'table.highlightColumn.number'} = undef;
		}
	}

	$prefs->{'general.limit'} = undef if( ! $prefs->{'general.limit'} );
}

sub printVersion				# print out the current version
{

	print <<EOV;

t2t : Version $version

(c) Steven Scholnick <scholnicks\@gmail.com> 1996 -

t2t is published under a MIT license. See https://scholnick.net/license.txt for details.

EOV

}

sub version				# print out the current version
{
	printVersion();
	exit 0;
}

sub help		# the help screen
{

	printVersion();

	print <<EOH;
--class         CSS class for all tables
--dashes        ignore lines of dashes
--delim         change delimiter
--debug         turns on debug mode (implies --verbose)
--equal         ensures that all rows have the same number of columns
--header        make headers for columns
--help          this help screen
--highlight     highlight a column header
--html5         Output in HTML5 mode (--template can override)
--id            CSS id for all tables (should be used with --one)
--initFilePath  read the initialized from the specified file
--limit         limit the number of cells created
--nbsp          empty cells will be filled in with &nbsp;
--one           process the whole file as one big table
--overwrite     controls if t2t will overwrite existing .html files
--quiet         quiet mode
--style         CSS style for all tables
--squeeze       squeeze out extra fields, i.e. extra delimiters
--skipfields    skip a field
--tablesOnly	generate only HTML for the tables no surrounding HTML
--template      use the specified template file
--title         add a title to the page
--verbose       verbose mode. Prints processing details for each file
--version       prints version number
--wholeTable    synonym for --one

EOH
	exit 0;
}

__END__

    Revision History
	----------------

Version 1.00  : Completed 2/29/96
Version 1.50  : Completed 9/15/96
Version 1.60  : Completed 3/17/97
Version 1.75  : Completed 5/25/98
Version 1.90  : Completed 2/8/99
Version 2.00  : Completed 7/25/99
Version 2.10  : Completed 9/27/99
Version 2.20  : Completed 10/12/99
Version 2.30  : Completed 03/19/00
Version 3.00  : Completed 10/07/00
Version 3.01  : Completed 05/11/01
Version 3.50  : Completed 11/24/01
Version 3.60  : Completed 8/30/02
Version 4.00  : Completed 5/4/03
Version 4.10  : Completed 4/7/04
Version 4.20  : Completed 12/19/04
Version 4.30  : Completed 4/24/05
Version 4.32  : Completed 9/11/05
Version 4.3.3 : Completed 9/18/05
Version 4.3.4 : Completed 10/8/05
Version 4.3.5 : Completed 10/20/05
Version 4.3.6 : Completed 11/13/05
Version 5.0   : Completed 2/12/06
Version 5.1   : Completed 7/3/06
Version 5.2   : Completed 1/14/07
Version 5.3   : Completed 10/22/07
Version 6.0   : Completed 1/28/08
Version 6.1   : Completed 1/3/09
Version 7.0   : Completed 12/3/09
Version 7.1   : Completed 4/10/10
Version 7.2   : Completed 4/24/10

Version History

7.3.1
- Fixed HTML5 template

7.3
- Removed exec

7.2
- Added internal HTML5 support

7.1
- Added suppport for missing CSS table attributes: class, id, and style.


7.0
- Added support for template files
   * Removed --append
   * Removed top, headerFile and bottom RC options
- Removed HTML support (only XHMTL will be produced now)
   * Removed --xhtml
- Added --debug command line option
- Added --wholeTable as a synonym for --one
- Fixed issue with no data (correct error message is produced now)
- Internal cleanups

6.1
- Fixed empty row bug producing invalid XHTML
- Fixed empty row and squeeze bug
- Added one option as a synonym for wholeTable

6.0
- Added support for Excel, OpenOffice, and CSV files natively
- Fixed bug with limit.  It was failing
- Fixed bug with xhtml RC option
- Fixed bug with nbsp option
- Internal Cleanups

5.3
- Added -verbose command line option
- Updated -quiet option to silence all messages
- Added -overwrite to toggle the overwriting of existing .html files
- Fixed warnings
- ~ are allowed in .t2trc file paths
- Internal cleanups

5.2
- Removed deprecated RC files names
- Added option to ensure all rows with the same number of columns
- Updated the --limit command option to handle more columns than the input data

5.1
- Added a DOCTYPE for HTML files
- Added an always present summary attribute for the tables
- All output files will be valid HTML or XHTML
- Renamed addParagraph option as addSpace

5.0
- Added XHTML

4.3.6
- Updated to allow zero attributes to perform work
- Added automated tests

4.3.5
- Fixed spelling for the highlightColumn attribute

4.3.4
- Added addParagraph RC option
- Updated squeeze option to handle a line with a delimiter on the end

4.3.3
- Changed version numbering scheme
- Fixed highlight column number bug

4.32
- Fixed a bug with spaces in the ledger colors
- Added header column hilighting

4.31
- Fixed skip fields
- Removed ledger command line option
- Added thead tag

4.30
- Better error reporting for mising rc file
- False, true, off, on, yes, & no can be used in the .t2trc file
- Added command line option --tablesOnly

4.20
- Added command line options, --nbsp && --limit
- All Errors and warnings are preceded with t2t:
- Fixed init file searching.  If a command line specified rc file is missing,
  the default rc file is no longer used.  A warning is produced.

4.10
- Fixed command line option processing.  The command line was getting trumped by the .t2trc file
- Now uses GetOpt::Long for command line processing
	o Added long versions, e.g. --delim
	o Removed bundling
	o Added no versions, e.g. --noheader
- Removed the -T option
- Re-did the help screen

4.00
- Dropped classic MacOS support
- Allowed newlines in the rc file
- Fixed cellWidths, cellAlignments, and ledgerColors options
- Added back support for just .t2trc
- Added custom prefernces class to read in the preferences

3.60
- Internal changes
- Added -i command line option

3.50
- Mostly internal changes.
- Some command line option cleanup.
- New rc file format

3.01
- Fixed bug for Perl 5.6

3.00
- MAJOR changes!!
- re-wrote the whole table handling routines to be OO
- added support for any and all tags to table, cell, & body
- removed several of the command line arguments
- added 2 new command line arguments (quiet mode & meta file)
- cleaned up multi-platform support
- fixed directory bug
- initialization file changed
- changing the file extension will now always work
- removed checking for the caption on the previous non-delimited line
- ledger colors can be greater than 2
- skipfields now takes a regular expression (can match more than one column)
- added delimiter (and other options) to the initialization file

2.30
- minor fixes for the MacOS version

2.2
- added MacOS support

2.1
- added Win32 support
- both .t2trc and rc are looked for as init files
- when processing a directory, .html & .htm are now skipped
- the file extension is now replaced instead of just appending .html

2.0
- added more HTML options to both the table & cell tags
- added ledger options
- Perl 5 only
- completed re-arranged the rc file
- cell alignments now affect the header
- finally fixed the directory and sub-directory processing

1.90
- bug fixes
- added the header color option

1.75
- added the cell alignment option
- added the caption tag

1.60
- some minor bug fixes with the one table option
- added the ability to add a file

1.50
- added whole table, skip field, and squeeze
- fixed the zero bug
- added the ability to read from stdin
- removed the redundant -o option

1.00
- initial release
