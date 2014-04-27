use File::Copy;
$repo -> config -> bool('diff.mnemonicprefix', 0);

my $file2  = $repo -> workdir . 'diff2';
write_file($file2, "diff me too, biatch\n");

my $file3  = $repo -> workdir . 'diff3';
write_file($file3, "diff me also, biatch, i have some whitespace    \r\n");

$index -> add('diff2');
my $diff = $repo -> diff({
	'tree'   => $tree,
	'prefix' => { 'a' => 'aaa', 'b' => 'bbb' },
	'paths'  => [ 'diff' ]
});

file => diff --git aaa/diff bbb/diff
+++ bbb/diff
is $output, $expected;

$diff = $repo -> diff({
	'tree'   => $tree,
	'prefix' => { 'a' => 'aaa', 'b' => 'bbb' },
	'paths'  => [ 'diff' ],
	'flags'  => {
		'reverse' => 1
	}
});
$expected = <<'EOS';
file => diff --git bbb/diff aaa/diff
deleted file mode 100644
index 6afc8a6..0000000
--- bbb/diff
+++ /dev/null
hunk => @@ -1 +0,0 @@
del => diff me, biatch
EOS

$output = capture_stdout { $diff -> print("patch", $printer) };
$diff = $repo -> diff({
	'tree'   => $tree,
	'paths'  => [ 'diff2' ]
});

$expected = <<'EOS';
file => diff --git a/diff2 b/diff2
new file mode 100644
index 0000000..e6ada20
--- /dev/null
+++ b/diff2
hunk => @@ -0,0 +1 @@
add => diff me too, biatch
EOS

$output = capture_stdout { $diff -> print("patch", $printer) };
is $output, $expected;

$diff = $repo -> diff({
	'tree'   => $tree,
	'paths'  => [ 'diff3' ],
	'flags'  => {
		'ignore_whitespace' => 1,
		'ignore_whitespace_eol' => 1
	}
});

$expected = '';

$output = capture_stdout { $diff -> print("patch", $printer) };
is $output, $expected;

$diff = $repo -> diff({
	'tree'   => $tree
});

file => A	diff2
is $diff -> delta_count, 2;
my @patches = $diff -> patches;
is scalar(@patches), 2;

foreach my $patch (@patches) {
	my @hunks = $patch -> hunks;
	is $patch -> hunk_count, 1;
	is scalar(@hunks), 1;

	my $hunk = $hunks[0];
	isa_ok $hunk, 'Git::Raw::Diff::Hunk';
	is $hunk -> new_start, 1;
	is $hunk -> new_lines, 1;
	is $hunk -> old_start, 0;
	is $hunk -> old_lines, 0;
	is $hunk -> header, '@@ -0,0 +1 @@';
}

$expected = <<'EOS';
diff --git a/diff b/diff
new file mode 100644
index 0000000..6afc8a6
--- /dev/null
+++ b/diff
@@ -0,0 +1 @@
+diff me, biatch
EOS

is $patches[0] -> buffer, $expected;
is_deeply $patches[0] -> line_stats, {
	'context' => 0, 'additions' => 1, 'deletions' => 0
};

my $delta = $patches[0] -> delta;
isa_ok $delta, 'Git::Raw::Diff::Delta';
is $delta -> file_count, 1;
is $delta -> status, "added";
is_deeply $delta -> flags, [];

my $old_file = $delta -> old_file;
isa_ok $old_file, 'Git::Raw::Diff::File';
is $old_file -> id, '0' x 40;
is $old_file -> path, 'diff';
is_deeply $old_file -> flags, ['valid_id'];
is_deeply $old_file -> mode, 'new';

my $new_file = $delta -> new_file;
isa_ok $new_file, 'Git::Raw::Diff::File';
is substr($new_file -> id, 0, 7), '6afc8a6';
is $new_file -> path, 'diff';
is_deeply $new_file -> flags, ['valid_id'];
is_deeply $new_file -> mode, 'blob';

$expected = <<'EOS';
diff --git a/diff2 b/diff2
new file mode 100644
index 0000000..e6ada20
--- /dev/null
+++ b/diff2
@@ -0,0 +1 @@
+diff me too, biatch
EOS

is $patches[1] -> buffer, $expected;
is_deeply $patches[1] -> line_stats, {
	'context' => 0, 'additions' => 1, 'deletions' => 0
};

$diff = $tree1 -> diff({
	'tree' => $tree2,
	'prefix' => { 'a' => 'aaa', 'b' => 'bbb' },
});
file => diff --git aaa/test3/under/the/tree/test3 bbb/test3/under/the/tree/test3
+++ bbb/test3/under/the/tree/test3
is $diff -> delta_count, 1;
@patches = $diff -> patches;
is scalar(@patches), 1;

$delta = $patches[0] -> delta;
is $delta -> old_file -> id, '0' x 40;
is substr($delta -> new_file -> id, 0, 7), 'c7eaef2';


$index -> add('diff');
$index -> add('diff2');
my $index_tree1 = $repo -> lookup($index -> write_tree);

move($file, $file.'.moved');
$index -> remove('diff');
$index -> add('diff.moved');
my $index_tree2 = $repo -> lookup($index -> write_tree);

my $tree_diff = $index_tree1 -> diff({
	'tree'   => $index_tree2
});

is $tree_diff -> delta_count, 2;
@patches = $tree_diff -> patches;

$expected = <<'EOS';
diff --git a/diff b/diff
deleted file mode 100644
index 6afc8a6..0000000
--- a/diff
+++ /dev/null
@@ -1 +0,0 @@
-diff me, biatch
EOS

is $patches[0] -> buffer, $expected;

$expected = <<'EOS';
diff --git a/diff.moved b/diff.moved
new file mode 100644
index 0000000..6afc8a6
--- /dev/null
+++ b/diff.moved
@@ -0,0 +1 @@
+diff me, biatch
EOS

is $patches[1] -> buffer, $expected;

my $stats = $tree_diff -> stats;
isa_ok $stats, 'Git::Raw::Diff::Stats';
is $stats -> insertions, 1;
is $stats -> deletions, 1;
is $stats -> files_changed, 2;

$expected = <<'EOS';
 diff       | 1 -
 diff.moved | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 diff
 create mode 100644 diff.moved
EOS

is $stats -> buffer({
	'flags' => {
		'full'    => 1,
		'summary' => 1,
	}
}), $expected;

$expected = <<'EOS';
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 diff
 create mode 100644 diff.moved
EOS

is $stats -> buffer({
	'flags' => {
		'short'    => 1,
		'summary'  => 1,
	}
}), $expected;

$tree_diff -> find_similar;
is $tree_diff -> delta_count, 1;
@patches = $tree_diff -> patches;

$expected = <<'EOS';
diff --git a/diff b/diff.moved
index 6afc8a6..6afc8a6 100644
--- a/diff
+++ b/diff.moved
EOS

is $patches[0] -> buffer, $expected;

$stats = $tree_diff -> stats;
isa_ok $stats, 'Git::Raw::Diff::Stats';
is $stats -> insertions, 0;
is $stats -> deletions, 0;
is $stats -> files_changed, 1;

$expected = <<'EOS';
 diff => diff.moved | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
EOS

is $stats -> buffer({
	'flags' => {
		'full'    => 1,
		'summary' => 1,
	}
}), $expected;

$expected = <<'EOS';
 1 file changed, 0 insertions(+), 0 deletions(-)
EOS

is $stats -> buffer({
	'flags' => {
		'short'    => 1,
		'summary' => 1,
	}
}), $expected;

my $content = <<'EOS';
AAAAAAAAAA
AAAAAAAAAA
AAAAAAAAAA
AAAAAAAAAA
AAAAAAAAAA
EOS

write_file("$file.moved", $content);
$index -> add('diff.moved');
$index_tree1 = $repo -> lookup($index -> write_tree);

move($file.'.moved', $file);
$index -> remove('diff.moved');

$content = <<'EOS';
AAAAAAAAAA
AAAAAAAAAA
AAAAZZAAAA
AAAAAAAAAA
AAAAAAAAAA
EOS

write_file($file, $content);
$index -> add('diff');
$index_tree2 = $repo -> lookup($index -> write_tree);

$tree_diff = $index_tree1 -> diff({
	'tree'   => $index_tree2,
	'flags'  => {
		'all' => 1
	}
});

is $tree_diff -> delta_count, 2;
$tree_diff -> find_similar;
is $tree_diff -> delta_count, 1;
@patches = $tree_diff -> patches;

$expected = <<'EOS';
diff --git a/diff.moved b/diff
index 5b96873..f97fd8f 100644
--- a/diff.moved
+++ b/diff
@@ -1,5 +1,5 @@
 AAAAAAAAAA
 AAAAAAAAAA
-AAAAAAAAAA
+AAAAZZAAAA
 AAAAAAAAAA
 AAAAAAAAAA
EOS

is $patches[0] -> buffer, $expected;

$content = <<'EOS';
 AAAAAAAAAA
AAAAAAAAAA
AAAAZZAAAA
AAAAAAAAAA
 AAAAAAAAAA
EOS

write_file($file, $content);
$index -> add('diff');
$index_tree2 = $repo -> lookup($index -> write_tree);

$tree_diff = $index_tree1 -> diff({
	'tree'   => $index_tree2,
	'flags'  => {
		'all' => 1
	}
});

is $tree_diff -> delta_count, 2;
$tree_diff -> find_similar;
is $tree_diff -> delta_count, 1;
@patches = $tree_diff -> patches;
