#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;

for my $host (@ARGV) {
    my $open = scan_ports($host);
    print "$host\n";
    print "    $_\n" for @$open;
}

sub scan_ports {
    my $host = shift;

    my @open;
    for my $port (qw( 22 80 443 8000 8030 8020 8089 9997 )) {

        my $socket = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Proto    => 'tcp',
            Type     => SOCK_STREAM,
            Timeout  => 1,
        );

        if ($socket) {
            push @open, $port;
            shutdown($socket, 2);
        }
    }

    return \@open;
}

