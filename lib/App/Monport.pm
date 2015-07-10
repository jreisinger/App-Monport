package App::Monport;
use App::Cmd::Setup -app;

our $VERSION = '0.04';

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

 $ monport base --name localhost 127.0.0.1

Later on check whether some changes in ports' state took place:

 $ monport diff --name localhost

To check regularly create a cronjob like:

 * 21 * * 5      monport --diff --name localhost --email jdoe@example.com

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

Copyright (C) 2015 by Jozef Reisinger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
