package T2t::TemplateProcessor;

use T2t::Utilities;

use base qw(T2t::BaseClass);

sub new
{
    my $package = shift;

    bless {
       template => shift,
       title    => shift
    }, $package;
}

sub process
{
	my ($self,$tables) = @_;

	my $template  = $self->{template};
	my $title = $self->{title};

	while ($template =~ /{file path="(.*)"}/img)
	{
		my $contents = getFileData($1);
		$template =~ s/{file path="$1"}/$contents/;
	}

	$template =~ s/{title}/$title/g;
	$template =~ s/{data}/$tables/g;

	return $template;
}

1;

__END__

=head1 AUTHOR INFORMATION

Copyright 2000-, Steven Scholnick <scholnicks@gmail.com>

t2t is published under MIT.  See license.html for details

