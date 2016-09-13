package Dist::Zilla::Plugin::Regexp::Pattern;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Moose;
use namespace::autoclean;
#use Module::Load;

with (
    'Dist::Zilla::Role::InstallTool',
);

sub setup_installer {
    my $self = shift;

    my $prereqs_hash = $self->zilla->prereqs->as_string_hash;

    # check that Regexp::Pattern is mentioned as DevelopRecommends
    unless (exists $prereqs_hash->{develop}{recommends}{'Regexp::Pattern'}) {
        unless (-f "lib/Regexp/Pattern.pm") { # exception for Regexp-Pattern dist
            $self->log_fatal(["Regexp::Pattern not specified as DevelopRecommends prerequisite"]);
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

=item * Make sure that L<Regexp::Pattern> is added as a DevelopRecommends prerequisite

This is an informal way to express that the module I<follows the specification>
specified in L<Regexp::Pattern>.

=back


=head1 SEE ALSO

L<Regexp::Pattern>

L<Pod::Weaver::Plugin::Regexp::Pattern>
