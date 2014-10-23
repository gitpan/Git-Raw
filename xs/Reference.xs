MODULE = Git::Raw			PACKAGE = Git::Raw::Reference

SV *
lookup(class, name, repo)
	SV *class
	SV *name
	SV *repo

	CODE:
		Reference ref;

		int rc = git_reference_lookup(
			&ref, GIT_SV_TO_PTR(Repository, repo),
			SvPVbyte_nolen(name)
		);
		git_check_error(rc);

		GIT_NEW_OBJ_DOUBLE(RETVAL, class, ref, repo);

	OUTPUT: RETVAL

void
delete(self)
	SV *self

	CODE:
		int rc;
		Reference ref = GIT_SV_TO_PTR(Reference, self);

		rc = git_reference_delete(ref);
		git_check_error(rc);

		sv_setiv(SvRV(self), 0);

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
			case GIT_REF_OID: type = newSVpv("direct", 0); break;
			case GIT_REF_SYMBOLIC: type = newSVpv("symbolic", 0); break;
			default: break;
		}

		RETVAL = type;

	OUTPUT: RETVAL

SV *
owner(self)
	SV *self

	CODE:
		if (!SvROK(self)) Perl_croak(aTHX_ "Not a reference");

		SV *r = xs_object_magic_get_struct(aTHX_ SvRV(self));
		if (!r) Perl_croak(aTHX_ "Invalid object");

		RETVAL = newRV_inc(r);

	OUTPUT: RETVAL

SV *
target(self, ...)
	Reference self

	PROTOTYPE: $;$
	CODE:
		int rc;
		SV *result;

		if (items > 1)
			warn("Second argument (former repo) is ignored. In future versions this will be fatal error");

		switch (git_reference_type(self)) {
			case GIT_REF_OID: {
				git_object *obj;
				const git_oid *oid;

				oid = git_reference_target(self);

				rc = git_object_lookup(
					&obj, git_reference_owner(self), oid, GIT_OBJ_ANY
				);
				git_check_error(rc);

				result = git_obj_to_sv(obj);
				break;
			}

			case GIT_REF_SYMBOLIC: {
				Reference ref;
				const char *target;

				target = git_reference_symbolic_target(self);

				rc = git_reference_lookup(&ref, git_reference_owner(self), target);
				git_check_error(rc);

				result = sv_setref_pv(
					newSV(0), "Git::Raw::Reference", ref
				);
				break;
			}

			default: Perl_croak(aTHX_ "Invalid reference type");
		}

		RETVAL = result;

	OUTPUT: RETVAL

bool
is_branch(self)
	Reference self

	CODE:
		RETVAL = git_reference_is_branch(self);

	OUTPUT: RETVAL

bool
is_packed(self)
	Reference self

	CODE:
		RETVAL = git_reference_is_packed(self);

	OUTPUT: RETVAL

bool
is_remote(self)
	Reference self

	CODE:
		RETVAL = git_reference_is_remote(self);

	OUTPUT: RETVAL

void
DESTROY(self)
	SV *self

	CODE:
		git_reference_free(GIT_SV_TO_PTR(Reference, self));
		SvREFCNT_dec(xs_object_magic_get_struct(aTHX_ SvRV(self)));
