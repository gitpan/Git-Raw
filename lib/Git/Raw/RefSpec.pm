package Git::Raw::RefSpec;
{
  $Git::Raw::RefSpec::VERSION = '0.16';
}

use strict;
use warnings;

=head1 NAME

Git::Raw::RefSpec - Git refspec class

=head1 VERSION

version 0.16

=head1 DESCRIPTION

A C<Git::Raw::RefSpec> represents a Git refspec.

=head1 METHODS

=head2 dst( )

Retrieve the destination specifier.

=head2 src( )

Retrieve the source specifier.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::RefSpec
