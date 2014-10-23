#!perl

use Test::More;

use Git::Raw;
use Cwd qw(abs_path);

my $path = abs_path('t/test_repo');
my $repo = Git::Raw::Repository -> open($path);

my $name = 'some_remote';
my $url  = 'git://github.com/ghedo/a_git_repository.git';

my $github = Git::Raw::Remote -> add($repo, $name, $url);

is $github -> name, $name;
is $github -> url, $url;

my $remotes = $repo -> remotes;

is $remotes -> [0] -> name, $name;
is $remotes -> [0] -> url, $url;

is $remotes -> [0] -> fetchspec -> dst, 'refs/remotes/some_remote/*';
is $remotes -> [0] -> fetchspec -> src, 'refs/heads/*';

is $remotes -> [0] -> pushspec -> dst, undef;
is $remotes -> [0] -> pushspec -> src, undef;

is $remotes -> [1], undef;

$name = 'github';
$url  = 'git://github.com/ghedo/p5-Git-Raw.git';

is $github -> name($name), $name;
is $github -> url($url), $url;

is $github -> fetchspec -> dst, 'refs/remotes/github/*';
is $github -> fetchspec -> src, 'refs/heads/*';

is $github -> pushspec -> dst, undef;
is $github -> pushspec -> src, undef;

unless ($ENV{NETWORK_TESTING} or $ENV{RELEASE_TESTING}) {
	diag('remote fetch tests require network');
	done_testing;
	exit;
}

$github -> connect('fetch');
is $github -> is_connected, 1;

$github -> download;
$github -> update_tips;

my $ref = Git::Raw::Reference -> lookup('refs/remotes/github/master', $repo);
is $ref -> type, 'direct';

my $head = $ref -> target($repo);
isa_ok $head, 'Git::Raw::Commit';

is $head -> author -> name, 'Alessandro Ghedini';

done_testing;
