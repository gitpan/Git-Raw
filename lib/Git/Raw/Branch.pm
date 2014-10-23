package Git::Raw::Branch;
{
  $Git::Raw::Branch::VERSION = '0.16';
}

use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Branch - Git branch class

=head1 VERSION

version 0.16

=head1 DESCRIPTION

Helper class for branch manipulation. Note that a Git branch is nothing more
than a L<Git::Raw::Reference>, so this class inherits all methods from it.

=head1 METHODS

=head2 create( $repo, $name, $target )

Create a new branch (aka a L<Git::Raw::Branch>) given a name and a target
object (either a L<Git::Raw::Commit> or a L<Git::Raw::Tag>).

=head2 lookup( $repo, $name, $is_local )

Retrieve the L<Git::Raw::Branch> corresponding to the given branch name.

=head2 move( $name, $force )

Rename the branch to C<$name>.

=head2 foreach( $repo, $callback )

Run C<$callback> for every branch in the repo. The callback receives a
L<Git::Raw::Branch> object. Non-zero return value stops the loop.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Branch
