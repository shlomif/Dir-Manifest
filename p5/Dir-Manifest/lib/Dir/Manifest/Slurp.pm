package Dir::Manifest::Slurp;

use strict;
use warnings;

use Socket qw(:crlf);

use parent qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [qw( as_lf )] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();

sub as_lf
{
    my ($s) = @_;
    $s =~ s#$CRLF#$LF#g;
    return $s;
}

1;

__END__

=head1 NAME

Dir::Manifest::Slurp - utility functions for slurping .

=head1 EXPORTS

=head2 my $new_string = as_lf($string)

Returns the string with all CRLF newlines converted to LF. See
L<https://en.wikipedia.org/wiki/Newline> .

=cut
