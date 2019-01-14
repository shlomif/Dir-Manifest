package Dir::Manifest;

use strict;
use warnings;

use 5.014;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use Moo;

has 'manifest_fn' => ( is => 'ro', required => 1 );
has 'dir'         => ( is => 'ro', required => 1 );

my $ALLOWED = qr/[a-zA-Z0-9_\-\.=]/;
my $ALPHAN  = qr/[a-zA-Z0-9_]/;
has '_keys' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my @lines = path( $self->manifest_fn )->lines( { chomp => 1 } );
        my $ret   = +{};

        foreach my $l (@lines)
        {
            if ( $l !~ /\A(?:$ALLOWED)+\z/ )
            {
                die
"Invalid characters in key \"$l\"! We only allow A-Z, a-z, 0-9, _, dashes and equal signs.";
            }
            if ( $l !~ /\A$ALPHAN/ )
            {
                die qq#Key does not start with an alphanumeric - "$l"!#;
            }
            if ( $l !~ /$ALPHAN\z/ )
            {
                die qq#Key does not end with an alphanumeric - "$l"!#;
            }
            $ret->{$l} = 1;
        }
        return $ret;
    }
);

sub get_keys
{
    my ($self) = @_;

    return [ sort { $a cmp $b } keys %{ $self->_keys } ];
}

1;

=head1 NAME

Dir::Manifest - treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs

=head1 DESCRIPTION

Here is the primary use case: you have several long texts (and/or binary blobs) that you
wish to load from the code (e.g: for the "want"/expected values of tests) and you wish to
conventiently edit them, track them and maintain them. Using L<Dir::Manifest> you can
put each in a separate file in a directory, create a manifest file listing all valid
filenames/key and then say something like
C<<< my $text = $dir->text("deal24solution.txt", {lf => 1}) >>>. And hopefully it will
be done securely and reliably.

=head1 METHODS

=head2 $self->manifest_fn()

The path to the manifest file.

=head2 $self->dir()

The path to the directory containing the texts and blobs as files.

=head2 $self->get_keys()

Returns a sorted array reference containing the available keys as strings.

=cut
