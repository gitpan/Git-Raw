use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.033

use Test::More  tests => 19 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Git/Raw.pm',
    'Git/Raw/Blob.pm',
    'Git/Raw/Branch.pm',
    'Git/Raw/Commit.pm',
    'Git/Raw/Config.pm',
    'Git/Raw/Cred.pm',
    'Git/Raw/Diff.pm',
    'Git/Raw/Index.pm',
    'Git/Raw/Push.pm',
    'Git/Raw/RefSpec.pm',
    'Git/Raw/Reference.pm',
    'Git/Raw/Remote.pm',
    'Git/Raw/Repository.pm',
    'Git/Raw/Signature.pm',
    'Git/Raw/Stash.pm',
    'Git/Raw/Tag.pm',
    'Git/Raw/Tree.pm',
    'Git/Raw/TreeEntry.pm',
    'Git/Raw/Walker.pm'
);



# no fake home requested

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, '-Mblib', '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


