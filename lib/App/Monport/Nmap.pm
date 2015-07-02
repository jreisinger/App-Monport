package App::Monport::Nmap;

use 5.006;
use strict;
use warnings;
use Exporter qw(import);
use File::Path qw(make_path);
use Nmap::Parser;
use File::Basename qw(basename);

our $VERSION = '0.01';

our @EXPORT = qw(list_basescans set_vars do_basescan print_basescan email_diffs print_diffs);

my $scan_name;
my $nmap_exe;
my $verbose;
my $base_dir = "$ENV{HOME}/.monport";
my $path;
my $base_file;

sub set_vars {
    ($scan_name, $nmap_exe, $verbose) = @_;

    $scan_name =~ s/\s+/_/g;

    $path      = "$base_dir/$scan_name";
    $base_file = "$path/base.xml";
}

sub email_diffs {

}

sub print_diffs {
    print get_diffs();
}

sub list_basescans {
    for my $dir (glob "$base_dir/*") {
        (my $name = basename $dir) =~ s/_/ /g;
        print "$name\n";
    }
}

sub get_basescan_opts_and_args {
    my $base    = shift;
    my $session = $base->get_session();

    my ( $nmap_opts, $targets );
    for my $part ( split ' ', $session->scan_args ) {
        if ( $part =~ /^\-/ ) {
            next if $part eq "-oX";
            push @$nmap_opts, $part;
        } elsif ( not $part =~ /\// ) {
            push @$targets, $part;
        }
    }

    return $nmap_opts, $targets;
}

sub get_diffs {
    my $base = new Nmap::Parser;
    my $curr = new Nmap::Parser;

    $base->parsefile($base_file);    #load previous state
    my ( $nmap_opts, $targets ) = get_basescan_opts_and_args($base);

    $curr->parsescan( $nmap_exe, @$nmap_opts, @$targets );   #scan current hosts

    my $msg = "";
    for my $ip ( $curr->get_ips ) {

        #assume that IPs in base == IPs in curr scan
        my $ip_base = $base->get_host($ip);
        my $ip_curr = $curr->get_host($ip);
        my %port    = ();

        next unless $ip_base and $ip_curr;

        #find ports that are open that were not open before
        #by finding the difference in port lists
        my @diff =
          grep { $port{$_} < 2 }
          ( map { $port{$_}++; $_ }
              ( $ip_curr->tcp_open_ports, $ip_base->tcp_open_ports ) );

        my $hostname = do {
            if   ( $ip_curr->hostname ) { $ip_curr->hostname }
            else                        { '' }
        };

        if (@diff) {
            $msg .= "$ip ($hostname) has changes in port(s) state\n";
            for my $port (@diff) {
                my $servicename = $ip_curr->tcp_service($port)->name // '';
                my $state = do {
                    if ( grep $port eq $_, $ip_curr->tcp_open_ports ) {
                        'not-open => open';
                    } else {
                        'open => not-open';
                    }
                };
                $msg .= "  $port ($servicename) -- $state\n";
            }
        }
    }
    return $msg;
}

sub do_basescan {
    my ( $nmapopts, $targets ) = @_;

    print "--> Doing the base scan ...\n" if $verbose;
    make_path $path if not -d $path;
    if ( -e $base_file ) {
        die
          "Base scan for '$scan_name' has already been done ($base_file), exiting ...\n";
    } else {
        system "$nmap_exe @$nmapopts -oX $base_file @$targets > /dev/null";
    }
}

sub print_basescan {
    my $np = new Nmap::Parser;
    $np->parsefile($base_file);

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
