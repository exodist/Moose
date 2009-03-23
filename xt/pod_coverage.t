#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

# This is a stripped down version of all_pod_coverage_ok which lets us
# vary the trustme parameter per module.
my @modules = all_modules();
plan tests => scalar @modules;

my %trustme = (
    'Moose'                  => ['make_immutable'],
    'Moose::Meta::Attribute' => [ 'interpolate_class', 'throw_error' ],
    'Moose::Meta::Class'     => [
        qw( check_metaclass_compatibility
            construct_instance
            create_error
            create_immutable_transformer
            raise_error
            )
    ],
    'Moose::Meta::Method'           => ['throw_error'],
    'Moose::Meta::Method::Accessor' => [
        qw( generate_accessor_method
            generate_accessor_method_inline
            generate_clearer_method
            generate_predicate_method
            generate_reader_method
            generate_reader_method_inline
            generate_writer_method
            generate_writer_method_inline
            )
    ],
    'Moose::Meta::Method::Constructor' => [
        qw( attributes
            generate_constructor_method
            generate_constructor_method_inline
            initialize_body
            meta_instance
            new
            options
            )
    ],
    'Moose::Meta::Method::Destructor' => [ 'initialize_body', 'options' ],
    'Moose::Role'                     => [
        qw( after
            around
            augment
            before
            extends
            has
            inner
            make_immutable
            override
            super
            with )
    ],
);

for my $module ( sort @modules ) {
    my $trustme = [];
    if ( $trustme{$module} ) {
        my $methods = join '|', @{ $trustme{$module} };
        $trustme = [qr/^(?:$methods)$/];
    }

    pod_coverage_ok(
        $module, { trustme => $trustme },
        "Pod coverage for $module"
    );
}
