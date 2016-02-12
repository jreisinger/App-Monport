package App::Monport;
use App::Cmd::Setup -app;

our $VERSION = '0.07';

=for HTML <a href="https://travis-ci.org/jreisinger/App-Monport"><img src="https://travis-ci.org/jreisinger/App-Monport.svg?branch=master"></a>

=head1 NAME

App::Monport - Monitor network ports for changes

=head1 SYNOPSIS

Run this to see available commands:

 $ monport

=head1 DESCRIPTION

Use this application to find out whether some new ports have been opened or
existing ones have been closed. New open ports mean bigger attack surface and
consequently higher security risk. If a port gets closed it might indicate a
problem with a network service.

The application works by comparing the actual state of ports (open or closed)
with the baseline scan. Any found differences are reported (via command line
interface, email, twitter). C<Nmap> is used for doing the port scanning so you
need to have it installed.

First you should run a base scan, like:

 $ monport base --name "test scan" localhost 192.168.1.0/24

Later on check whether some changes in ports' state took place:

 $ monport diff --name "test scan"
 192.168.1.10 () has changes in port(s) state
  3333 (dec-notes) -- not-open => open

To check regularly create a cronjob like:

 PERL5LIB=/home/jdoe/perl5/lib/perl5

 * 21 * * 5 /home/jdoe/perl5/bin/monport diff --name "test scan" --email jdoe@example.com

To list the executed base scans:

 $ monport list
 noname
 test scan

To see the results of the base scan:

 $ monport list -p -n 'test scan'
 Base scan done: Fri Feb 12 08:41:06 2016

 127.0.0.1 (localhost)
     22 (ssh)

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

1;
