#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    use_ok('App::Monport::Nmap') || print "Bail out!\n";
}

my %fixed_scan_name = (
    my_scan   => "my_scan",
    "my scan" => "my_scan",
    "My Scan" => "My_Scan",
    "my  Scan " => "my_Scan_",
);

# Is regex substitution working correctly?
for my $name ( keys %fixed_scan_name ) {
    set_vars( $name, "/usr/bin/nmap" );
    is( $App::Monport::Nmap::scan_name, $fixed_scan_name{$name}, "Scan name '$name'" );
}

done_testing();
