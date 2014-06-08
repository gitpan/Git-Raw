#!perl

BEGIN {
	require Config;
	Config -> import;
	require Test::More;
	Test::More -> import;

	if (!$Config{useithreads}) {
		Test::More::plan(skip_all => 'thread tests require perl to be built with interpreter thread support');
	}
}

BEGIN {
	require threads;
	threads -> import;
	require Git::Raw;
	Git::Raw -> import;
}

use Cwd qw(abs_path);

my $path = abs_path('t/test_repo');
my $repo = Git::Raw::Repository -> open($path);

my $index = $repo -> index;
my $remote = Git::Raw::Remote -> create($repo, 'dummy', 'me@somewhere.com:somewhere.git');

my $var = 1;
$remote -> callbacks({ update_tips => sub { ++$var; print STDERR "Doing it yeah: $var!\n" }});

sub start_thread {
	sleep 1;
	print "\nThread started\n\n";
	print "THREAD: Undeffing\n";
	undef $index;
	undef $repo;
	print "THREAD: Undeffed\n";
}

my $thr1 = threads->create ('start_thread');
sleep 2;
my $thr2 = threads->create ('start_thread');


print "MAIN: Undeffing\n";
undef $repo;
undef $index;


print "MAIN: Sleeping\n";
sleep 2;
print "MAIN: Done sleeping\n";


$thr1 -> join;
$thr2 -> join;


ok 1;
done_testing;
