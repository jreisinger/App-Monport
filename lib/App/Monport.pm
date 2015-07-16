package App::Monport;
use App::Cmd::Setup -app;

our $VERSION = '0.06';

=for HTML <a href="https://travis-ci.org/jreisinger/App-Monport"><img src="https://travis-ci.org/jreisinger/App-Monport.svg?branch=master"></a>

=head1 NAME

App::Monport - Monitor network ports for changes

=head1 SYNOPSIS

Run this to see available sub-commands (use -h to get help):

 $ monport

=head1 DESCRIPTION

Use this application to find out whether some new ports have been opened (or
existing ones have been closed). More open ports mean bigger attack surface and
consequently higher security risk.

First you should run a base scan, like:

 $ monport base --name "test scan" localhost 192.168.1.0/24

Later on check whether some changes in ports' state took place:

 $ monport diff --name "test scan"
 192.168.1.10 () has changes in port(s) state
  3333 (dec-notes) -- not-open => open

To check regularly create a cronjob like:

 * 21 * * 5      monport diff --name "test scan" --email jdoe@example.com

=head1 INSTALLATION

To install this module, run:

 $ cpanm App::Monport

when using L<App::cpanminus>. Of course you can use your favorite CPAN client
or install manually by cloning the L</"SOURCE REPOSITORY"> and then running:

 perl Build.PL
 ./Build
 ./Build test
 ./Build install

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
