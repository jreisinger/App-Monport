package App::Monport;
use strict;
use warnings;
use IO::Socket;
use List::Util qw(shuffle);
use Nmap::Parser;

our $VERSION = '1.01';

=for HTML <a href="https://travis-ci.org/jreisinger/App-Monport"><img src="https://travis-ci.org/jreisinger/App-Monport.svg?branch=master"></a>

=head1 NAME

App::Monport - Monitor network ports for changes

=head1 SYNOPSIS

 $ monport

=head1 DESCRIPTION

Use this application to find out whether some new ports have been opened or
existing ones have been closed. New open ports mean bigger attack surface and
consequently higher security risk. On the other hand if a port gets closed it
might indicate a problem with a network service.

The application works by comparing the actual state of ports (open or closed)
with the expected state defined in the configuration file.

=head1 INSTALLATION

To install this module run:

 $ cpan App::Monport

or

 $ cpanm App::Monport

when using L<App::cpanminus>.

To install manually clone the L</"SOURCE REPOSITORY"> and then run (on Unix):

 perl Build.PL
 ./Build
 ./Build test
 ./Build install

For more see L<StackOverflow|http://stackoverflow.com/questions/65865/whats-the-easiest-way-to-install-a-missing-perl-module>
or L<CPAN|http://www.cpan.org/modules/INSTALL.html> instructions.

=head1 SOURCE REPOSITORY

L<http://github.com/jreisinger/App-Monport>

=head1 AUTHOR

Jozef Reisinger, E<lt>reisinge@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Jozef Reisinger.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

sub scan_ports {
    my $host = shift;

    my $np   = new Nmap::Parser;

    #runs the nmap command with hosts and parses it automagically
    $np->parsescan( '/usr/bin/nmap', '', $host );

    my ($h) = $np->all_hosts();
    my @ports = $h->tcp_ports(q(open));

    return \@ports;
}

#sub scan_ports {
#    my $host = shift;
#    my @open;
#    print "scanning $host: \n";
#    my $ports = default_ports();
#    for my $port (@$ports) {
#        my $socket = IO::Socket::INET->new(
#            PeerAddr => $host,
#            PeerPort => $port,
#            Proto    => 'tcp',
#            Type     => SOCK_STREAM,
#            Timeout  => 1,
#        );
#
#        if ($socket) {
#            push @open, $port;
#            shutdown( $socket, 2 );
#        }
#    }
#
#    return \@open;
#}

1;
