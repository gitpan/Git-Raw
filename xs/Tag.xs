MODULE = Git::Raw			PACKAGE = Git::Raw::Tag

SV *
create(class, repo, name, msg, tagger, target)
	SV *class
	SV *repo
	SV *name
	SV *msg
	Signature tagger
	SV *target

	PREINIT:
		int rc;
		Tag tag;

		git_oid oid;
		git_object *obj;
		Repository repo_ptr;

	CODE:
		obj = git_sv_to_obj(target);

		if (obj == NULL)
			croak_usage("Invalid type for '%s', expected a commitish", "target");

		repo_ptr = GIT_SV_TO_PTR(Repository, repo);

		rc = git_tag_create(
			&oid, repo_ptr -> repository, git_ensure_pv(name, "name"),
			obj, tagger, git_ensure_pv(msg, "msg"), 0
		);
		git_check_error(rc);

		rc = git_tag_lookup(&tag, repo_ptr -> repository, &oid);
		git_check_error(rc);

		GIT_NEW_OBJ_WITH_MAGIC(
			RETVAL, SvPVbyte_nolen(class), tag, SvRV(repo)
		);

	OUTPUT: RETVAL

SV *
lookup(class, repo, id)
	SV *class
	SV *repo
	SV *id

	PREINIT:
		int rc;

		Tag tag;
		git_oid oid;
		Repository repo_ptr;

		STRLEN len;
		const char *id_str;

	CODE:
		id_str = git_ensure_pv_with_len(id, "id", &len);

		rc = git_oid_fromstrn(&oid, id_str, len);
		git_check_error(rc);

		repo_ptr = GIT_SV_TO_PTR(Repository, repo);
		rc = git_tag_lookup_prefix(&tag, repo_ptr -> repository, &oid, len);

		if (rc == GIT_ENOTFOUND) {
			RETVAL = &PL_sv_undef;
		} else {
			git_check_error(rc);

			GIT_NEW_OBJ_WITH_MAGIC(
				RETVAL, SvPVbyte_nolen(class), tag, SvRV(repo)
			);
		}

	OUTPUT: RETVAL

SV *
owner(self)
	SV *self

	PREINIT:
		SV *repo;

	CODE:
		repo = GIT_SV_TO_MAGIC(self);
		RETVAL = newRV_inc(repo);

	OUTPUT: RETVAL

void
foreach(class, repo, cb, ...)
	SV *class
	SV *repo
	SV *cb

	PROTOTYPE: $$$;$
	PREINIT:
		int rc;

	CODE:
		git_foreach_payload payload = {
			GIT_SV_TO_PTR(Repository, repo),
			repo,
			cb,
			1,
			1
		};

		if (items == 4 && SvOK(ST(3))) {
			const char *type = git_ensure_pv(ST(3), "type");

			if (strcmp(type, "lightweight") == 0)
				payload.annotated = 0;
			else if (strcmp(type, "annotated") == 0)
				payload.lightweight = 0;
			else {
				if (strcmp(type, "all") != 0)
					croak_usage("Invalid value for 'type', expected "
						"'all', 'lightweight' or 'annotated'");
			}
		}

		rc = git_tag_foreach(
			payload.repo_ptr -> repository,
			git_tag_foreach_cbb,
			&payload
		);

		if (rc != GIT_EUSER)
			git_check_error(rc);

void
delete(self)
	SV *self

	PREINIT:
		int rc;

		Tag tag_ptr;
		Repository repo;

	CODE:
		tag_ptr = GIT_SV_TO_PTR(Tag, self);

		repo = INT2PTR(
			Repository, SvIV((SV *) GIT_SV_TO_MAGIC(self))
		);

		rc = git_tag_delete(repo -> repository, git_tag_name(tag_ptr));
		git_check_error(rc);

		git_tag_free(tag_ptr);
		sv_setiv(SvRV(self), 0);

SV *
id(self)
	Tag self

	CODE:
		RETVAL = git_oid_to_sv(git_tag_id(self));

	OUTPUT: RETVAL

SV *
name(self)
	Tag self

	CODE:
		RETVAL = newSVpv(git_tag_name(self), 0);

	OUTPUT: RETVAL

SV *
message(self)
	Tag self

	CODE:
		RETVAL = newSVpv(git_tag_message(self), 0);

	OUTPUT: RETVAL

SV *
tagger(self)
	Tag self

	PREINIT:
		int rc;
		Signature tagger, result;

	CODE:
		RETVAL = &PL_sv_undef;

		if ((tagger = (Signature) git_tag_tagger(self)) != NULL) {
			rc = git_signature_dup(&result, tagger);
			git_check_error(rc);

			GIT_NEW_OBJ(
				RETVAL, "Git::Raw::Signature", result
			);
		}

	OUTPUT: RETVAL

SV *
target(self)
	SV *self

	PREINIT:
		int rc;
		git_object *obj;

	CODE:
		rc = git_tag_target(&obj, GIT_SV_TO_PTR(Tag, self));
		git_check_error(rc);

		RETVAL = git_obj_to_sv(obj, GIT_SV_TO_MAGIC(self));

	OUTPUT: RETVAL

void
DESTROY(self)
	SV *self

	CODE:
		git_tag_free(GIT_SV_TO_PTR(Tag, self));
		SvREFCNT_dec(GIT_SV_TO_MAGIC(self));
