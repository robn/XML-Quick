use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'XML::Quick',
    license             => 'perl',
    dist_author         => 'Robert Norris <Robert.Norris@its.monash.edu.au>',
    dist_version_from   => 'lib/XML/Quick.pm',
    requires => {
        'Perl6::Export::Attrs' => 0,
        'Scalar::Util' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'XML-Quick-*' ],
);

$builder->create_build_script();
