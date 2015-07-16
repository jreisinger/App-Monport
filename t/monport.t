#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use IO::Socket;

SKIP: {
    skip "/usr/bin/nmap not present", 1
      unless -e "/usr/bin/nmap";

    # Execute base scan
    system
      "perl bin/monport base --name 'localhost test' 127.0.0.1 > /dev/null";

    my $out;

    # Execute diff scan
    $out = `perl bin/monport diff --name 'localhost test'`;
    is( $out, "", "No output (no changes in ports' status)" );

    # Find a free port and open it (listen at it)
    my $server;
    my $port = 1024;
    until ($server) {
        $server = IO::Socket::INET->new(
            LocalPort => $port++,
            Type      => SOCK_STREAM,
            Reuse     => 1,
            Listen    => 10
          )
          or warn
          "Couldn't be a tcp server on port $port: $@. Trying next one ...";
    }

    # Execute diff scan again (now with new port open)
    $out = `perl bin/monport diff --name 'localhost test'`;
    like(
        $out,
        qr/has changes/,
        "There is output (some changes in port $port status)"
    );

    close($server);

    # Cleanup
    END {
        unlink "$ENV{HOME}/.monport/localhost_test/base.xml";
        rmdir "$ENV{HOME}/.monport/localhost_test";
    }
}

done_testing();
