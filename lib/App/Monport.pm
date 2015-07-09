package App::Monport;
use App::Cmd::Setup -app;

our $VERSION = '0.02';

=head1 NAME

App::Monport - monitor network ports for changes

=head1 SYNOPSIS

Run this to see available sub-commands (use -h to get help):

 $ monport

=head1 DESCRIPTION

Use this application to find out whether some new ports have been opened (or
existing ones have been closed). More open ports mean bigger attack surface and
consequently higher security risk.

Firs you should run a base scan:

 $ monport base --name localhost 127.0.0.1

Later on check whether some changes in ports's state took place:

 $ monport diff --name localhost

To check regularly, create a cronjob like:

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

=cut

1;
