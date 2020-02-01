package T2t::TemplateFactory;

use strict;
use warnings;

use T2t::Utilities;
use T2t::UserPreferencesCache;

use base qw(Exporter);
our @EXPORT = qw(getTemplate);

sub getTemplate
{
	my $prefs = T2t::UserPreferencesCache->getInstance();

	return "{data}" if $prefs->isTablesOnly();

	my $path = $prefs->getTemplateFile();

	debug("Template path = ", $path);

	return getDefaultTemplate() if ! $path;

	return getHTML5Template() if $path eq 't2t-internal-html5';

	return getFileData($path);
}

sub getDefaultTemplate
{
	return <<'_EOHTML_';
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
   <title>{title}</title>
   <meta name="generator" content="t2t" />
</head>
<body>

{data}

</body>
</html>
_EOHTML_
}

sub getHTML5Template
{
	return <<'_EOHTML_';
<!doctype html>
<html lang="en">
<head>
   <meta charset="utf-8" />
   <meta name="generator" content="t2t" />
   <title>{title}</title>

   <!--[if lt IE 9]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
   <![endif]-->
</head>
<body>

{data}

</body>
</html>
_EOHTML_
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.txt for details


