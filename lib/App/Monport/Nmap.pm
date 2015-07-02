package App::Monport::Nmap;

use Exporter qw(import);
use File::Path qw(make_path);
use Nmap::Parser;

our @EXPORT = qw(do_basescan print_basescan);

my $nmap_exe = "/usr/bin/nmap";
my $scan_name = "noname";
my $file = "$ENV{HOME}/.monport/$scan_name/base.xml";
my $verbose = 1;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

sub do_basescan {
    my ($nmapopts, $targets) = @_;

    print "--> Doing the base scan ...\n" if $verbose;
    make_path "$ENV{HOME}/.monport/$scan_name" if not -d "$ENV{HOME}/.monport/$scan_name";
    system "$nmap_exe @$nmapopts -oX $file @$targets > /dev/null";
}

sub print_basescan {
    my $np = new Nmap::Parser;
    $np->parsefile($file);

    my $session = $np->get_session;
    print "Base scan done: " . $session->time_str . "\n\n";

    for
      my $host ( sort { $a->ipv4_addr cmp $b->ipv4_addr } $np->all_hosts('up') )
    {
        my $ip       = $host->ipv4_addr;
        my $hostname = do {
            if   ( $host->hostname ) { $host->hostname }
            else                     { '' }
        };
        print "$ip ($hostname)\n";
        for ( $host->tcp_open_ports ) {
            my $servicename = do {
                if ( $host->tcp_service($_)->name ) {
                    $host->tcp_service($_)->name;
                } else {
                    '';
                }
            };
            print "    $_ ($servicename)\n";
        }
    }
}

1;
