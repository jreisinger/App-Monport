#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use App::Monport;

my $host = q(scanme.nmap.org);
my $verbose = 1;
my $open = scan_ports($host, $verbose);
for my $expected (qw(22 80)) {
    ok( grep( $expected == $_, @$open ), "$host has port $expected open" );
}

done_testing();
