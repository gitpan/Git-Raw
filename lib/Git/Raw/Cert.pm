package Git::Raw::Cert;
$Git::Raw::Cert::VERSION = '0.48';
use strict;
use warnings;

=head1 NAME

Git::Raw::Cert - Git certificate class

=head1 VERSION

version 0.48

=head1 DESCRIPTION

A L<Git::Raw::Cert> object represents a certificate.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 type( )

Type of certificate, either C<"x509"> or C<"hostkey">.

=head1 AUTHOR

Jacques Germishuys <jacquesg@striata.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Jacques Germishuys.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw::Cert
