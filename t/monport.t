#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use IO::Socket;
use App::Monport;

my $ports = App::Monport::default_ports();
ok( @$ports > 2000, 'we have plenty of ports to scan' );

my $open = App::Monport::scan_ports('google.com');
is( "@$open", "80 443", 'google.com port scanning' );

done_testing();
