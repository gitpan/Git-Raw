package Git::Raw::Walker;
{
  $Git::Raw::Walker::VERSION = '0.16';
}

use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Walker - Git revwalker class

=head1 VERSION

version 0.16

=head1 DESCRIPTION

A C<Git::Raw::Walker> represents a graph walker used to walk through the
repository's revisions (sort of like C<git log>).

=head1 METHODS

=head2 create( $repo )

Create a new walker to iterate over repository's revisions.

=head2 push( $commit )

Push a L<Git::Raw::Commit> to the list of commits to be used as roots when
starting a revision walk.

=head2 next( )

Retrieve the next commit from the revision walk.

=head2 reset( )

Reset the revision walker (this is done automatically at the end of a walk).

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Walker
