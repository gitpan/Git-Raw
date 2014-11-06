package Git::Raw::Remote;
$Git::Raw::Remote::VERSION = '0.48';
use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Remote - Git remote class

=head1 VERSION

version 0.48

=head1 SYNOPSIS

    use Git::Raw;

    # open the Git repository at $path
    my $repo = Git::Raw::Repository -> open($path);

    # add a new remote
    my $remote = Git::Raw::Remote -> create($repo, 'origin', $url);

    # set the acquire credentials callback
    $remote -> callbacks({
      'credentials' => sub { Git::Raw::Cred -> userpass($usr, $pwd) },
      'update_tips' => sub {
        my ($ref, $a, $b) = @_;
        print "Updated $ref: $a -> $b", "\n";
      }
    });

    # connect the remote
    $remote -> connect('fetch');

    # fetch from the remote and update the local tips
    $remote -> download;
    $remote -> update_tips;

    # disconnect
    $remote -> disconnect;

    my $empty_repo = Git::Raw::Repository -> new;
    my $anonymous_remote = Git::Raw::Remote -> create_anonymous($repo, $url, undef);
    my $list = $anonymous_remote -> ls;

=head1 DESCRIPTION

A C<Git::Raw::Remote> represents a Git remote.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 create( $repo, $name, $url )

Create a remote with the default fetch refspec and add it to the repository's
configuration.

=head2 create_anonymous( $repo, $url, $fetch_refspec )

Create a remote in memory (anonymous).

=head2 load( $repo, $name )

Load an existing remote. Returns a L<Git::Raw::Remote> object if the remote
was found, otherwise C<undef>.

=head2 owner( )

Retrieve the L<Git::Raw::Repository> owning the remote.

=head2 default_branch( )

Retrieve the default branch of remote repository, that is, the branch which
HEAD points to. If the remote does not support reporting this information
directly, it performs the guess as git does, that is, if there are multiple
branches which point to the same commit, the first one is chosen. If the master
branch is a candidate, it wins. If the information cannot be determined, this
function will return C<undef>. Note, this function should only be called after
the remote has established a connection.

=head2 name( [ $name, \@problems ] )

Retrieve the name of the remote. If C<$name> is passed, the remote's name will
be updated and returned. Non-default refspecs cannot be renamed and will be
store in C<@problems> if provided.

=head2 url( [ $url ] )

Retrieve the URL of the remote. If C<$url> is passed, the remote's URL will be
updated and returned.

=head2 pushurl( [ $url ] )

Retrieve the push URL for the remote. If C<$url> is passed, the remote's push
URL will be updated and returned.

=head2 add_fetch( $spec )

Add a fetch spec to the remote.

=head2 add_push( $spec )

Add a push spec to the remote.

=head2 clear_refspecs( )

Clear the remote's refspecs.

=head2 refspec_count( )

Retrieve the refspec count.

=head2 refspecs( )

Retrieve the remote's refspecs. Returns a list of L<Git::Raw::RefSpec> objects.

=head2 ls( )

Retrieve the list of refs at the remote. Returns a hash reference where the key
is the name of the reference, and the value is a hash reference containing the
following values:

=over 4

=item * "local"

Whether the reference exists locally.

=item * "id"

The OID of the reference.

=item * "lid"

The local OID of the reference (optional).

=back

=head2 callbacks( \%callbacks )

=over 4

=item * "credentials"

The callback to be called any time authentication is required to connect to the
remote repository. The callback receives a string C<$url> containing the URL of
the remote, the C<$user> extracted from the URL and a list of supported
authentication C<$types>. The callback should return either a L<Git::Raw::Cred>
object or alternatively C<undef> to abort the authentication process. B<Note:>
this callback may be invoked more than once. C<$types> may contain one or more
of the following:

=over 8

=item * "userpass_plaintext"

Plaintext username and password.

=item * "ssh_key"

A SSH key from disk

=item * "ssh_custom"

A SSH key with a custom signature function.

=item * "ssh_interactive"

Keyboard-interactive based SSH authentication

=item * "username"

Username-only credential information.

=item * "default"

A key for NTLM/Kerberos default credentials.

=back

=item * "certificate_check"

Callback to be invoked if cert verification fails. The callback receives a
L<Git::Raw::Cert::X509> or L<Git::Raw::Cert::HostKey> object, a truthy
value C<$valid> and C<$host>. This callback should return 1 to allow the
connection to proceed or 0 to abort. Returning a negative number indicates
an error.

=item * "sideband_progress"

Textual progress from the remote. Text sent over the progress side-band will be
passed to this function (this is the 'counting objects' output or any other
information the remote sends). The callback receives a string C<$msg>
containing the progress information.

=item * "transfer_progress"

During the download of new data, this will be regularly called with the current
count of progress done by the indexer. The callback receives the following integers:
C<$total_objects>, C<$received_objects>, C<$local_objects>, C<$total_deltas>,
C<$indexed_deltas> and C<$received_bytes>.

=item * "update_tips"

Each time a reference is updated locally, this function will be called with
information about it. The callback receives a string containing the reference
C<$ref> of the reference that was updated, and the two OID's C<$a> before and
after C<$b> the update. C<$a> will be C<undef> if the reference was created,
likewise C<$b> will be C<undef> if the reference was removed.

=back

=head2 fetch( )

Download new data and update tips. Convenience function to connect to a remote,
download the data, disconnect and update the remote-tracking branches.

=head2 connect( $direction )

Connect to the remote. The C<$direction> should either be C<"fetch"> or C<"push">.

=head2 disconnect( )

Disconnect the remote.

=head2 download( )

Download the remote packfile.

=head2 save( )

Save the remote to its repository's config.

=head2 update_tips( )

Update the tips to the new status.

=head2 is_connected( )

Check if the remote is connected.

=head2 is_url_valid( $url )

Check whether C<$url> is a valid remote URL.

=head2 is_url_supported( $url )

Check whether C<$url> the passed URL is supported by this version of the
library.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

Jacques Germishuys <jacquesg@striata.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Remote
