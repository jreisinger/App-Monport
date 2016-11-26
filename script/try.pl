#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;
use Storable;

my $file = q/open_ports.data/;
my $open_ports = retrieve($file) if -f $file;

#use Data::Dumper;
#print Dumper $open_ports;

for my $host (@ARGV) {
    my $open = scan_ports($host);
    print "$host: @$open\n";

    if ( exists $open_ports->{$host} ) {

        # a new port got open?
        for my $port (@$open) {
            print "port opened $host:$port\n"
              if not grep $port == $_, @{ $open_ports->{$host} };
        }

        # an open port got closed?
        for my $port ( @{ $open_ports->{$host} } ) {
            print "port closed $host:$port\n"
              if not grep $port == $_, @$open;
        }
    }

    $open_ports->{$host} = $open;
    store $open_ports, $file;
}

sub scan_ports {
    my $host = shift;

    my @open;
    for my $port (qw( 22 80 443 1234 8000 8030 8020 8089 9997 )) {

        my $socket = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Proto    => 'tcp',
            Type     => SOCK_STREAM,
            Timeout  => 1,
        );

        if ($socket) {
            push @open, $port;
            shutdown( $socket, 2 );
        }
    }

    return \@open;
}

