package Git::Raw::Diff;
{
  $Git::Raw::Diff::VERSION = '0.25'; # TRIAL
}

use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Diff - Git diff class

=head1 VERSION

version 0.25

=head1 DESCRIPTION

A C<Git::Raw::Diff> represents the diff between two entities.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 merge( $from )

Merge the given diff with the C<Git::Raw::Diff> C<$from>.

=head2 patch( $callback )

Generate text output from the diff object. The C<$callback> will be called for
each line of the diff with two arguments: the first one represents the type of
the patch line (C<"ctx"> for context lines, C<"add"> for additions, C<"del">
for deletions, C<"file"> for file headers, C<"hunk"> for hunk headers or
C<"bin"> for binary data) and the second argument contains the content of the
patch line.

=head2 compact( $callback )

Generate compact text output from a diff object. Differently from C<patch()>,
this function only passes the names and statuses of changed files to the
callback.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Diff
