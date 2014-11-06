package Git::Raw::Blob;
$Git::Raw::Blob::VERSION = '0.46';
use strict;
use warnings;
use overload
	'""'       => sub { return $_[0] -> id },
	'eq'       => \&_cmp,
	'ne'       => sub { !&_cmp(@_) };

use Git::Raw;

=head1 NAME

Git::Raw::Blob - Git blob class

=head1 VERSION

version 0.46

=head1 DESCRIPTION

A L<Git::Raw::Blob> represents a Git blob.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 create( $repo, $buffer )

Create a new blob from the given buffer.

=head2 lookup( $repo, $id )

Retrieve the blob corresponding to C<$id>. This function is pretty much the
same as C<$repo-E<gt>lookup($id)> except that it only returns blobs. If the blob
doesn't exist, this function wil return C<undef>.

=head2 owner( )

Retrieve the L<Git::Raw::Repository> owning the blob.

=head2 content( )

Retrieve the raw content of a blob.

=head2 size( )

Retrieve the size of the raw content of a blob.

=head2 id( )

Return the raw ID (the SHA-1 hash) of the blob.

=head2 is_binary( )

Determine if the blob content is most certainly binary or not.

=head2 is_blob( )

Returns true.

=cut

=head2 is_tree( )

Returns false.

=cut

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

sub _cmp {
	if (defined($_[0]) && defined ($_[1])) {
		my ($a, $b);

		$a = $_[0] -> id;

		if (ref($_[1])) {
			if (!$_[1] -> can('id')) {
				return 0;
			}
			$b = $_[1] -> id;
		} else {
			$b = "$_[1]";
		}

		return $a eq $b;
	}

	return 0;
}

1; # End of Git::Raw::Blob
