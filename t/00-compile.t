use 5.006;
use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.043

use Test::More  tests => 44 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Git/Raw.pm',
    'Git/Raw/Blame.pm',
    'Git/Raw/Blame/Hunk.pm',
    'Git/Raw/Blob.pm',
    'Git/Raw/Branch.pm',
    'Git/Raw/Cert.pm',
    'Git/Raw/Cert/HostKey.pm',
    'Git/Raw/Cert/X509.pm',
    'Git/Raw/Commit.pm',
    'Git/Raw/Config.pm',
    'Git/Raw/Cred.pm',
    'Git/Raw/Diff.pm',
    'Git/Raw/Diff/Delta.pm',
    'Git/Raw/Diff/File.pm',
    'Git/Raw/Diff/Hunk.pm',
    'Git/Raw/Diff/Stats.pm',
    'Git/Raw/Error.pm',
    'Git/Raw/Error/Category.pm',
    'Git/Raw/Filter.pm',
    'Git/Raw/Filter/List.pm',
    'Git/Raw/Filter/Source.pm',
    'Git/Raw/Graph.pm',
    'Git/Raw/Index.pm',
    'Git/Raw/Index/Conflict.pm',
    'Git/Raw/Index/Entry.pm',
    'Git/Raw/Merge/File/Result.pm',
    'Git/Raw/Note.pm',
    'Git/Raw/Patch.pm',
    'Git/Raw/PathSpec.pm',
    'Git/Raw/PathSpec/MatchList.pm',
    'Git/Raw/Push.pm',
    'Git/Raw/RefSpec.pm',
    'Git/Raw/Reference.pm',
    'Git/Raw/Reflog.pm',
    'Git/Raw/Reflog/Entry.pm',
    'Git/Raw/Remote.pm',
    'Git/Raw/Repository.pm',
    'Git/Raw/Signature.pm',
    'Git/Raw/Stash.pm',
    'Git/Raw/Tag.pm',
    'Git/Raw/Tree.pm',
    'Git/Raw/Tree/Builder.pm',
    'Git/Raw/Tree/Entry.pm',
    'Git/Raw/Walker.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


