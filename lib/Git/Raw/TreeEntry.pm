package Git::Raw::TreeEntry;
{
  $Git::Raw::TreeEntry::VERSION = '0.10';
}

use strict;
use warnings;

=head1 NAME

Git::Raw::TreeEntry - Git tree entry class

=head1 VERSION

version 0.10

=head1 DESCRIPTION

A C<Git::Raw::TreeEntry> represents an entry in a L<Git::Raw::Tree>.

=head1 METHODS

=head2 id( )

Retrieve the id of the tree entry, as string.

=head2 name( )

Retrieve the filename of the tree entry.

=head2 object( $repo )

Retrieve the object pointed by the tree entry given a L<Git::Raw::Repository>
where to lookup the pointed object. This function may return a L<Git::Raw::Blob>,
a L<Git::Raw::Commit>, a L<Git::Raw::Tag> or a L<Git::Raw::Tree>.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::TreeEntry
