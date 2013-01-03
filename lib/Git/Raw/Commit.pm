package Git::Raw::Commit;
{
  $Git::Raw::Commit::VERSION = '0.19';
}

use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Commit - Git commit class

=head1 VERSION

version 0.19

=head1 SYNOPSIS

    use Git::Raw;

    # open the Git repository at $path
    my $repo = Git::Raw::Repository -> open($path);

    # add a file to the repository default index
    my $index = $repo -> index;
    $index -> add('test');
    $index -> write;

    # create a new tree out of the repository index
    my $tree_id = $index -> write_tree;
    my $tree    = $repo -> lookup($tree_id);

    # retrieve user's name and email from the Git configuration
    my $config = $repo -> config;
    my $name   = $config -> str('user.name');
    my $email  = $config -> str('user.email');

    # create a new Git signature
    my $me = Git::Raw::Signature -> now($name, $email);

    # create a new commit out of the above tree, with the repository HEAD as
    # parent
    my $commit = $repo -> commit(
      'some commit', $me, $me, [ $repo -> head -> target ], $tree
    );

=head1 DESCRIPTION

A C<Git::Raw::Commit> represents a Git commit.

=head1 METHODS

=head2 create( $repo, $msg, $author, $committer, [@parents], $tree )

Create a new commit given a message, two L<Git::Raw::Signature> (one is the
commit author and the other the committer), a list of parent commits and a
L<Git::Raw::Tree>.

=head2 lookup( $repo, $id )

Retrieve the commit corresponding to C<$id>. This function is pretty much
the same as C<$repo-E<gt>lookup($id)> except that it only returns commits.

=head2 id( )

Retrieve the id of the commit, as string.

=head2 message( )

Retrieve the message of the commit.

=head2 author( )

Retrieve the L<Git::Raw::Signature> representing the author of the commit.

=head2 committer( )

Retrieve the L<Git::Raw::Signature> representing the committer.

=head2 time( )

Retrieve the committer time of the commit.

=head2 offset( )

Retrieve the committer time offset (in minutes) of the commit.

=head2 tree( )

Retrieve the L<Git::Raw::Tree> the commit points to.

=head2 parents( )

Retrieve the list of parents of the commit.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Commit
