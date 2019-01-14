package Dir::Manifest::Slurp;

use strict;
use warnings;

use Socket qw(:crlf);

use parent qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [qw( as_lf slurp )] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();

sub as_lf
{
    my ($s) = @_;
    $s =~ s#$CRLF#$LF#g;
    return $s;
}

sub slurp
{
    my ( $fh, $opts ) = @_;

    if ( $opts->{raw} )
    {
        return $fh->slurp_raw;
    }
    else
    {
        my $ret = $fh->slurp_utf8;
        return $opts->{lf} ? as_lf($ret) : $ret;
    }
}

1;

__END__

=head1 NAME

Dir::Manifest::Slurp - utility functions for slurping .

=head1 EXPORTS

=head2 my $new_string = as_lf($string)

Returns the string with all CRLF newlines converted to LF. See
L<https://en.wikipedia.org/wiki/Newline> .

=head2 my $contents = slurp(path("foo.txt"), { lf => 1, }) # utf-8 after using as_lf
=head2 my $contents = slurp(path("foo.txt"), { raw => 1, })
=head2 my $contents = slurp(path("foo.txt"), { }) # utf-8

Accepts a L<Path::Tiny> object and an options hash reference.
=cut
