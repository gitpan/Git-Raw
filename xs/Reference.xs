MODULE = Git::Raw			PACKAGE = Git::Raw::Reference

Reference
lookup(class, name, repo)
	SV *class
	SV *name
	Repository repo

	CODE:
		STRLEN len;
		Reference r;

		const char *name_str = SvPVbyte(name, len);
		int rc = git_reference_lookup(&r, repo, name_str);
		git_check_error(rc);

		RETVAL = r;

	OUTPUT: RETVAL

SV *
name(self)
	Reference self

	CODE:
		const char *msg = git_reference_name(self);
		RETVAL = newSVpv(msg, 0);

	OUTPUT: RETVAL

SV *
type(self)
	Reference self

	CODE:
		SV *type;

		switch (git_reference_type(self)) {
			case GIT_REF_OID: type = newSVpv(":direct", 0); break;
			case GIT_REF_SYMBOLIC: type = newSVpv(":symbolic", 0); break;
		}

		RETVAL = type;

	OUTPUT: RETVAL

SV *
target(self, repo)
	Reference self
	Repository repo

	CODE:
		int rc;
		SV *result;

		switch (git_reference_type(self)) {
			case GIT_REF_OID: {
				git_object *o;
				const git_oid *oid = git_reference_oid(self);

				rc = git_object_lookup(
					&o, repo, oid, GIT_OBJ_ANY
				);
				git_check_error(rc);

				result = git_obj_to_sv(o);
				break;
			}

			case GIT_REF_SYMBOLIC: {
				Reference f;
				const char *target = git_reference_target(self);

				rc = git_reference_lookup(&f, repo, target);

				result = sv_setref_pv(
					newSV(0), "Git::Raw::Reference",
					(void *) f
				);
				break;
			}

			default: Perl_croak(aTHX_ "Invalid reference type");
		}

		RETVAL = result;

	OUTPUT: RETVAL

void
DESTROY(self)
	Reference self

	CODE:
		git_reference_free(self);
