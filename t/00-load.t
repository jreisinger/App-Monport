#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'App::Monport::Nmap' ) || print "Bail out!\n";
}

diag( "Testing App::Monport::Nmap $App::Monport::Nmap::VERSION, Perl $], $^X" );
