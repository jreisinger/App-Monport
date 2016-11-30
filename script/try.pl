#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;
use Storable;
use File::Basename qw(dirname);
use YAML;
use File::Spec qw(catfile);

#my $file = q/open_ports.data/;
#my $open_ports = retrieve($file) if -f $file;

# load configuration from config file
my $conf_file = File::Spec->catfile( dirname($0), "monport.yml" );
die "'$conf_file' problem: $!" unless -e $conf_file;
my $content = eval { local ( @ARGV, $/ ) = ($conf_file); <>; };
my $config = Load($content);

#use Data::Dumper;
#print Dumper \$config;

for my $host (sort keys $config->{hosts}) {

    my $open = scan_ports($host);
    my $expected_open = $config->{hosts}{$host} // [];

    print "$host\n";

    for my $port (sort @$open) {
        print "  $port is open\n"
          unless grep $port == $_, @$expected_open;
    }

    for my $port (sort @$expected_open) {
        print "  $port is closed\n"
          unless grep $port == $_, @$open;
    }
}

=pod
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
=cut

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
