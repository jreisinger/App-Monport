package App::Monport::Nmap;

use 5.006;
use strict;
use warnings;
use Exporter qw(import);
use File::Path qw(make_path);
use Nmap::Parser;
use File::Basename qw(basename);
use Sys::Hostname qw(hostname);
use Email::MIME;
use Email::Sender::Simple;

our @EXPORT =
  qw(list_basescans set_vars do_basescan print_basescan email_diffs print_diffs);

our $base_dir = "$ENV{HOME}/.monport";

our $scan_name;
our $nmap_exe;
our $path;
our $base_file;

=head1 DESCRIPTION

The core functions are defined here.

=head1 FUNCTIONS

=head2 set_vars( $scan_name, $nmap_exe )

Set variables for this package.

=cut

sub set_vars {
    ( $scan_name, $nmap_exe ) = @_;

    $scan_name =~ s/\s+/_/g;

    $path      = "$base_dir/$scan_name";
    $base_file = "$path/base.xml";
}

=head2 email_diffs( @email_addresses )

If some differences in ports' status are found, send to to @email_addresses.

=cut

sub email_diffs {
    my @email_addresses = @_;

    my $diffs = get_diffs();
    if ($diffs) {
        sendMail( $_, "monport - $scan_name", $diffs ) for @email_addresses;
    }
}

=head2 sendMail( $to, $subject, $body )

Send email. Based on L<http://perldoc.perl.org/perlfaq9.html>.

=cut

sub sendMail {
    my ( $receiver, $subject, $mail_body ) = @_;

    # sender will the user running the program
    my $host  = hostname;
    my $login = getlogin || getpwuid($<) || "uknown";
    my $from  = "$login\@$host";

    # first, create your message
    my $message = Email::MIME->create(
        header_str => [
            From    => $from,
            To      => $receiver,
            Subject => $subject,
        ],
        attributes => {
            encoding => 'quoted-printable',
            charset  => 'utf-8',
        },
        body_str => $mail_body,
    );

    # send the message
    use Email::Sender::Simple qw(sendmail);
    sendmail($message);
}

=head2 print_diffs()

If some differences in ports' status are found, print them to STDOUT.

=cut

sub print_diffs {
    print get_diffs();
}

=head2 list_basescans()

List names of available base(line) scans.

=cut

sub list_basescans {
    for my $dir ( glob "$base_dir/*" ) {
        ( my $name = basename $dir) =~ s/_/ /g;
        print "$name\n";
    }
}

=head2 get_basescan_opts_and_args( $base )

Get nmap options and arguments used for a given base(line) scan. $base is
Nmap::Parser object.

=cut

sub get_basescan_opts_and_args {
    my $base    = shift;
    my $session = $base->get_session();

    my ( $nmap_opts, $targets );
    for my $part ( split ' ', $session->scan_args ) {
        if ( $part =~ /^\-/ ) {
            next if $part eq "-oX";
            push @$nmap_opts, $part;
        } elsif ( not $part =~ /^\// ) {
            push @$targets, $part;
        }
    }

    return $nmap_opts, $targets;
}

=head2 get_diffs()

Get differences in ports' status between a base(line) scan and a current scan

=cut

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

=head2 do_basescan( $nmapopts, $targets )

Execute base(line) scan.

=cut

sub do_basescan {
    my ( $nmapopts, $targets ) = @_;
    $nmapopts = [] unless $nmapopts;    # so that we don't get warning

    make_path $path if not -d $path;
    if ( -e $base_file ) {
        die
          "Base scan for '$scan_name' has already been done ($base_file), exiting ...\n";
    } else {
        system "$nmap_exe @$nmapopts -oX $base_file @$targets";
    }
}

=head2 print_basescan()

Print base scan results.

=cut

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
