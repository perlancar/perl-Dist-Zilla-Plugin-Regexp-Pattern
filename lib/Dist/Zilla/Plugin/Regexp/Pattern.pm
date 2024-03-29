package Dist::Zilla::Plugin::Regexp::Pattern;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Moose;
with 'Dist::Zilla::Role::AfterBuild';
with 'Dist::Zilla::Role::FileGatherer';
with 'Dist::Zilla::Role::PrereqSource';
#with 'Dist::Zilla::Role::RegexpPattern::CheckDefinesPattern';
use namespace::autoclean;

use PMVersions::Util qw(version_from_pmversions);

sub register_prereqs {
    my ($self) = @_;

    #return unless $self->check_dist_defines_regexp_pattern;

    $self->zilla->register_prereqs(
        {
            type  => 'requires',
            phase => 'develop',
        },
        'Test::Regexp::Pattern' => version_from_pmversions('Test::Regexp::Pattern') // '0.001',
    );
}

sub gather_files {
    my ($self) = @_;

    #return unless $self->check_dist_defines_regexp_pattern;

    my $filename = "xt/release/regexp-pattern.t";
    my $filecontent = <<_;
#!perl

# This file was automatically generated by ${\(__PACKAGE__)}.

use Test::More;

eval "use Test::Regexp::Pattern 0.001";
plan skip_all => "Test::Regexp::Pattern 0.001+ required for testing regexp patterns"
  if \$@;

regexp_patterns_in_all_modules_ok();
_

    $self->log(["Adding %s ...", $filename]);
    require Dist::Zilla::File::InMemory;
    $self->add_file(
        Dist::Zilla::File::InMemory->new({
            name => $filename,
            content => $filecontent,
        })
      );
}

sub after_build {
    my $self = shift;

    my $prereqs_hash = $self->zilla->prereqs->as_string_hash;

    # check that Regexp::Pattern is mentioned as DevelopRecommends
    unless (exists $prereqs_hash->{develop}{x_spec}{'Regexp::Pattern'}) {
        unless (-f "lib/Regexp/Pattern.pm") { # exception for Regexp-Pattern dist
            $self->log_fatal(["Regexp::Pattern not specified as prerequisite (phase=develop, rel=x_spec)"]);
        }
    }
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Plugin to use when building Regexp::Pattern::* distribution

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<dist.ini>:

 [Regexp::Pattern]


=head1 DESCRIPTION

This plugin is to be used when building C<Regexp::Pattern::*> distribution. It
currently does the following:

=over

=item * Create C<xt/release/regexp-pattern.t> test file which uses L<Test::Regexp::Pattern> to test yor regexp patterns

=item * Make sure that L<Regexp::Pattern> is added as a (phase=develop, rel=x_spec) prerequisite

This is a way to express that the module I<follows the specification> specified
in L<Regexp::Pattern>.

=back


=head1 SEE ALSO

L<Regexp::Pattern>

L<Pod::Weaver::Plugin::Regexp::Pattern>
