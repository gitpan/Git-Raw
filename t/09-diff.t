my $tree  = $repo -> head -> target -> tree;
my $tree2 = $repo -> head -> target -> tree;
my $tree1 = $repo -> head -> target -> parents -> [0] -> tree;
file => diff --git a/test3/under/the/tree/test3 b/test3/under/the/tree/test3
index 0000000..c7eaef2
+++ b/test3/under/the/tree/test3
add => +this is a third testdel => 
file => A	test3/under/the/tree/test3