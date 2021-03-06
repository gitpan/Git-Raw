package Git::Raw::Push;
$Git::Raw::Push::VERSION = '0.50';
use strict;
use warnings;

=head1 NAME

Git::Raw::Push - Git push class

=head1 VERSION

version 0.50

=head1 SYNOPSIS

    use Git::Raw;

    # open the Git repository at $path
    my $repo = Git::Raw::Repository -> open($path);

    # add a new remote
    my $remote = Git::Raw::Remote -> create($repo, 'origin', $url);

    # set the acquire credentials callback
    $remote -> callbacks({
      credentials => sub { Git::Raw::Cred -> userpass($usr, $pwd) }
    });

    # connect the remote
    $remote -> connect('push');

    # create a push object
    my $push = Git::Raw::Push -> new($remote);

    # add a refspec
    my $spec = "refs/heads/master:refs/heads/master";
    $push -> add_refspec($spec);
    $push -> callbacks({
      'status' => sub {
        my ($ref, $msg) = @_;

        if (!defined($msg)) {
          print "Updated $ref", "\n";
        } else {
          print STDERR "Update failed: $ref: $msg", "\n";
        }
      },
      'pack_progress' => sub {
        my ($stage, $current, $total) = @_;
        print "Packed $current objects\r";
      }
    });

    # perform the actual push
    if ($push -> finish) {
      if ($push -> unpack_ok) {
        print "References updated successfully", "\n";
      } else {
        print STDERR "Not all references updated", "\n";
      }
      $push -> update_tips;
    } else {
      print STDERR "Push failed", "\n";
    }

    # disconnect the remote
    $remote -> disconnect;

    # now fetch from the remote
    $remote -> connect('fetch');
    $remote -> download;
    $remote -> update_tips;
    $remote -> disconnect;

=head1 DESCRIPTION

Helper class for pushing.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 new( $remote )

Create a new push object.

=head2 add_refspec( $spec )

Add the C<$spec> refspec to the push object. Note that C<$spec> is a string.

=head2 callbacks( \%callbacks )

=over 4

=item * "transfer_progress"

During the upload of new data, this will reguarly be called with the transfer
progress. The callback receives the following integers:
C<$current>, C<$total> and C<$bytes>.

=item * "pack_progress"

During the packing of new data, this will reguarly be called with the progress
of the pack operation. Be aware that this is called inline with pack
building operations, so performance may be affected. The callback receives the
following integers:
C<$stage>, C<$current> and C<$total>.

=item * "status"

For each of the updated references, this will be called with a status report
for the reference. The callback receives C<$ref> and C<$msg> as strings. If
C<$msg> is defined, the reference mentioned in C<$ref> has not been updated.

=back

=head2 finish( )

Perform the actual push. Return a truthy value to indicate if the push was
successful.

=head2 unpack_ok( )

Check if the remote successfully unpacked.

=head2 update_tips( )

Update the tips to the new status.

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

1; # End of Git::Raw::Push
