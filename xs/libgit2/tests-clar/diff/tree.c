static git_diff_options opts;
static git_diff_list *diff;
static git_tree *a, *b;
static diff_expects expect;
	GIT_INIT_STRUCTURE(&opts, GIT_DIFF_OPTIONS_VERSION);

	memset(&expect, 0, sizeof(expect));

	diff = NULL;
	a = NULL;
	b = NULL;
	git_diff_list_free(diff);
	git_tree_free(a);
	git_tree_free(b);


	git_tree *c;
		diff, diff_file_cb, diff_hunk_cb, diff_line_cb, &expect));
	cl_assert_equal_i(5, expect.files);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(5, expect.hunks);
	cl_assert_equal_i(7 + 24 + 1 + 6 + 6, expect.lines);
	cl_assert_equal_i(1, expect.line_ctxt);
	cl_assert_equal_i(24 + 1 + 5 + 5, expect.line_adds);
	cl_assert_equal_i(7 + 1, expect.line_dels);
	memset(&expect, 0, sizeof(expect));
		diff, diff_file_cb, diff_hunk_cb, diff_line_cb, &expect));
	cl_assert_equal_i(2, expect.files);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(2, expect.hunks);
	cl_assert_equal_i(8 + 15, expect.lines);
	cl_assert_equal_i(1, expect.line_ctxt);
	cl_assert_equal_i(1, expect.line_adds);
	cl_assert_equal_i(7 + 14, expect.line_dels);
	git_tree *c, *d;
		diff, diff_file_cb, diff_hunk_cb, diff_line_cb, &expect));
	cl_assert_equal_i(3, expect.files);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(3, expect.hunks);
	cl_assert_equal_i(4, expect.lines);
	cl_assert_equal_i(0, expect.line_ctxt);
	cl_assert_equal_i(3, expect.line_adds);
	cl_assert_equal_i(1, expect.line_dels);
	git_tree *c;
		diff1, diff_file_cb, diff_hunk_cb, diff_line_cb, &expect));
	cl_assert_equal_i(6, expect.files);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(3, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(6, expect.hunks);
	cl_assert_equal_i(59, expect.lines);
	cl_assert_equal_i(1, expect.line_ctxt);
	cl_assert_equal_i(36, expect.line_adds);
	cl_assert_equal_i(22, expect.line_dels);
}
void process_tree_to_tree_diffing(
	const char *old_commit,
	const char *new_commit)
{
	g_repo = cl_git_sandbox_init("unsymlinked.git");

	cl_assert((a = resolve_commit_oid_to_tree(g_repo, old_commit)) != NULL);
	cl_assert((b = resolve_commit_oid_to_tree(g_repo, new_commit)) != NULL);

	cl_git_pass(git_diff_tree_to_tree(&diff, g_repo, a, b, &opts));

	cl_git_pass(git_diff_foreach(
		diff, diff_file_cb, NULL, NULL, &expect));
}

void test_diff_tree__symlink_blob_mode_changed_to_regular_file(void)
{
	/*
	* $ git diff  7fccd7..806999
	* diff --git a/include/Nu/Nu.h b/include/Nu/Nu.h
	* deleted file mode 120000
	* index 19bf568..0000000
	* --- a/include/Nu/Nu.h
	* +++ /dev/null
	* @@ -1 +0,0 @@
	* -../../objc/Nu.h
	* \ No newline at end of file
	* diff --git a/include/Nu/Nu.h b/include/Nu/Nu.h
	* new file mode 100644
	* index 0000000..f9e6561
	* --- /dev/null
	* +++ b/include/Nu/Nu.h
	* @@ -0,0 +1 @@
	* +awesome content
	* diff --git a/objc/Nu.h b/objc/Nu.h
	* deleted file mode 100644
	* index f9e6561..0000000
	* --- a/objc/Nu.h
	* +++ /dev/null
	* @@ -1 +0,0 @@
	* -awesome content
	*/

	process_tree_to_tree_diffing("7fccd7", "806999");

	cl_assert_equal_i(3, expect.files);
	cl_assert_equal_i(2, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_TYPECHANGE]);
}

void test_diff_tree__symlink_blob_mode_changed_to_regular_file_as_typechange(void)
{
	/*
	 * $ git diff  7fccd7..a8595c
	 * diff --git a/include/Nu/Nu.h b/include/Nu/Nu.h
	 * deleted file mode 120000
	 * index 19bf568..0000000
	 * --- a/include/Nu/Nu.h
	 * +++ /dev/null
	 * @@ -1 +0,0 @@
	 * -../../objc/Nu.h
	 * \ No newline at end of file
	 * diff --git a/include/Nu/Nu.h b/include/Nu/Nu.h
	 * new file mode 100755
	 * index 0000000..f9e6561
	 * --- /dev/null
	 * +++ b/include/Nu/Nu.h
	 * @@ -0,0 +1 @@
	 * +awesome content
	 * diff --git a/objc/Nu.h b/objc/Nu.h
	 * deleted file mode 100644
	 * index f9e6561..0000000
	 * --- a/objc/Nu.h
	 * +++ /dev/null
	 * @@ -1 +0,0 @@
	 * -awesome content
	*/

	opts.flags = GIT_DIFF_INCLUDE_TYPECHANGE;
	process_tree_to_tree_diffing("7fccd7", "a8595c");

	cl_assert_equal_i(2, expect.files);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_TYPECHANGE]);
}

void test_diff_tree__regular_blob_mode_changed_to_executable_file(void)
{
	/*
	 * $ git diff 806999..a8595c
	 * diff --git a/include/Nu/Nu.h b/include/Nu/Nu.h
	 * old mode 100644
	 * new mode 100755
	 */

	process_tree_to_tree_diffing("806999", "a8595c");

	cl_assert_equal_i(1, expect.files);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_DELETED]);
	cl_assert_equal_i(1, expect.file_status[GIT_DELTA_MODIFIED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_ADDED]);
	cl_assert_equal_i(0, expect.file_status[GIT_DELTA_TYPECHANGE]);