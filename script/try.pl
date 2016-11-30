#!/usr/bin/perl
use strict;
use warnings;
use YAML;
use File::Spec qw(catfile);
use File::Basename qw(dirname);
use IO::Socket;

# load configuration from a file
my $conf_file = File::Spec->catfile( dirname($0), "monport.yml" );
die "'$conf_file' problem: $!" unless -e $conf_file;
my $content = eval { local ( @ARGV, $/ ) = ($conf_file); <>; };
my $config = Load($content);

for my $host ( sort keys $config->{hosts} ) {

    my $open = scan_ports($host);
    my $expected_open = $config->{hosts}{$host} // [];

    print "$host\n";

    for my $port ( sort @$open ) {
        print "  $port is open\n"
          unless grep $port == $_, @$expected_open;
    }

    for my $port ( sort @$expected_open ) {
        print "  $port is closed\n"
          unless grep $port == $_, @$open;
    }
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
