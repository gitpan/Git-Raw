package Git::Raw::Blob;
{
  $Git::Raw::Blob::VERSION = '0.12';
}

use strict;
use warnings;

=head1 NAME

Git::Raw::Blob - Git blob class

=head1 VERSION

version 0.12

=head1 DESCRIPTION

A C<Git::Raw::Blob> represents a Git blob.

=head1 METHODS

=head2 lookup( $repo, $id )

Retrieve the blob corresponding to the given id. This function is pretty much
the same as C<$repo-E<gt>lookup($id)> except that it only returns blobs.

=head2 content( )

Retrieve the raw content of a blob.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Blob