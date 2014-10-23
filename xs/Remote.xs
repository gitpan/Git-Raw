MODULE = Git::Raw			PACKAGE = Git::Raw::Remote

Remote
new(class, repo, name, url, fetch)
	SV *class
	SV *repo
	SV *name
	SV *url
	SV *fetch

	CODE:
		Remote remote;
		Repository r = NULL;

		if (repo != &PL_sv_undef)
			r = GIT_SV_TO_PTR(Repository, repo);

		int rc = git_remote_new(
			&remote, r,
			SvPVbyte_nolen(name),
			SvPVbyte_nolen(url),
			SvPVbyte_nolen(fetch)
		);
		git_check_error(rc);

		RETVAL = remote;

	OUTPUT: RETVAL

Remote
add(class, repo, name, url)
	SV *class
	Repository repo
	SV *name
	SV *url

	CODE:
		Remote remote;

		int rc = git_remote_add(
			&remote, repo, SvPVbyte_nolen(name), SvPVbyte_nolen(url)
		);
		git_check_error(rc);

		RETVAL = remote;

	OUTPUT: RETVAL

SV *
name(self, ...)
	Remote self

	PROTOTYPE: $;$
	CODE:
		const char *name;

		if (items == 2) {
			const char *new = SvPVbyte_nolen(ST(1));

			int rc = git_remote_rename(self, new, NULL, NULL);
			git_check_error(rc);
		}

		name = git_remote_name(self);

		RETVAL = newSVpv(name, 0);

	OUTPUT: RETVAL

SV *
url(self, ...)
	Remote self

	PROTOTYPE: $;$
	CODE:
		const char *url;

		if (items == 2) {
			const char *new = SvPVbyte_nolen(ST(1));

			int rc = git_remote_set_url(self, new);
			git_check_error(rc);
		}

		url = git_remote_url(self);

		RETVAL = newSVpv(url, 0);

	OUTPUT: RETVAL

RefSpec
fetchspec(self, ...)
	Remote self

	PROTOTYPE: $;$
	CODE:
		RefSpec spec;

		if (items == 2) {
			const char *new = SvPVbyte_nolen(ST(1));

			int rc = git_remote_set_fetchspec(self, new);
			git_check_error(rc);
		}

		spec = (RefSpec) git_remote_fetchspec(self);

		RETVAL = spec;

	OUTPUT: RETVAL

RefSpec
pushspec(self, ...)
	Remote self

	PROTOTYPE: $;$
	CODE:
		RefSpec spec;

		if (items == 2) {
			const char *new = SvPVbyte_nolen(ST(1));

			int rc = git_remote_set_pushspec(self, new);
			git_check_error(rc);
		}

		spec = (RefSpec) git_remote_pushspec(self);

		RETVAL = spec;

	OUTPUT: RETVAL

void
connect(self, direction)
	Remote self
	SV *direction

	CODE:
		git_direction direct;
		const char *dir = SvPVbyte_nolen(direction);

		if (strcmp(dir, "fetch") == 0)
			direct = GIT_DIRECTION_FETCH;
		else if (strcmp(dir, "push") == 0)
			direct = GIT_DIRECTION_PUSH;
		else
			Perl_croak(aTHX_ "Invalid direction");

		int rc = git_remote_connect(self, direct);
		git_check_error(rc);

void
disconnect(self)
	Remote self

	CODE:
		git_remote_disconnect(self);

void
download(self)
	Remote self

	CODE:
		int rc = git_remote_download(self, NULL, NULL);
		git_check_error(rc);

void
save(self)
	Remote self

	CODE:
		int rc = git_remote_save(self);
		git_check_error(rc);

void
update_tips(self)
	Remote self

	CODE:
		int rc = git_remote_update_tips(self);
		git_check_error(rc);

void
cred_acquire(self, cb)
	Remote self
	SV *cb

	CODE:
		SvREFCNT_inc(cb);

		git_remote_set_cred_acquire_cb(self, git_cred_acquire_cbb, cb);

bool
is_connected(self)
	Remote self

	CODE:
		RETVAL = git_remote_connected(self);

	OUTPUT: RETVAL

void
DESTROY(self)
	Remote self

	CODE:
		git_remote_free(self);
