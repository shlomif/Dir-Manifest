package Dir::Manifest::Key;

use strict;
use warnings;
use 5.014;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use Moo;

has 'key' => ( is => 'ro', required => 1 );
has 'fh'  => ( is => 'ro', required => 1 );

1;

=head1 NAME

Dir::Manifest::Key - a Dir::Manifest key.

=head1 DESCRIPTION

Here is the primary use case: you have several long texts (and/or binary blobs) that you
wish to load from the code (e.g: for the "want"/expected values of tests) and you wish to
conventiently edit them, track them and maintain them. Using L<Dir::Manifest> you can
put each in a separate file in a directory, create a manifest file listing all valid
filenames/key and then say something like
C<<< my $text = $dir->text("deal24solution.txt", {lf => 1}) >>>. And hopefully it will
be done securely and reliably.

=head1 METHODS

=head2 $self->key()

The key as string.

=head2 $self->fh()

A L<Path::Tiny> object for reading from the file.

=cut
