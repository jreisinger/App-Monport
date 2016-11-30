package App::Monport;
use strict;

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

1;
