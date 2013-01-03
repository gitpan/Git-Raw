package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template = <<'TEMPLATE';
use Devel::CheckLib;

my $defines   = '';
my $libraries = '';

if (check_lib(lib => 'ssl')) {
  $defines   = "$defines -DGIT_SSL";
  $libraries = "$libraries -lssl -lcrypto";
  print "SSL support enabled\n";
}

sub MY::postamble {
  return <<"MAKE_LIBGIT2";
\$(MYEXTLIB):
	cd xs/libgit2 && \$(MAKE) -f Makefile.embed EXTRA_CFLAGS="$defines"

MAKE_LIBGIT2
}

# This Makefile.PL for {{ $distname }} was generated by Dist::Zilla.
# Don't edit it but the dist.ini used to construct it.
{{ $perl_prereq ? qq[BEGIN { require $perl_prereq; }] : ''; }}
use strict;
use warnings;
use ExtUtils::MakeMaker {{ $eumm_version }};
{{ $share_dir_block[0] }}
my {{ $WriteMakefileArgs }}

$WriteMakefileArgs{LIBS} = $libraries;

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
{{ $share_dir_block[1] }}
TEMPLATE

	return $template;
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	=> '-I. -Ixs/libgit2/include',
		OBJECT	=> '$(O_FILES) xs/libgit2/libgit2.a',
		MYEXTLIB => 'xs/libgit2/libgit2.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
