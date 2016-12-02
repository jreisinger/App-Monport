#!/usr/bin/perl
use strict;
use warnings;
use YAML::Tiny;
use File::Spec qw(catfile);
use File::Basename qw(dirname);


my $conf_file = File::Spec->catfile( dirname($0), "monport.yml" );

my $yaml;

if (@ARGV) {
    die "'$conf_file' already exists: $!" if -e $conf_file;
    $yaml = YAML::Tiny->new();
    for my $host (@ARGV) {
        my $open_ports = scan_ports($host);
        push @$yaml, { $host => $open_ports };
        $yaml->write('monport.yml');
    }
}

$yaml = YAML::Tiny->read($conf_file);

for my $hashref (@$yaml) {
    for my $host ( sort keys %$hashref ) {

        my $open = scan_ports($host);
        my $expected_open = $hashref->{$host} // [];

        print "$host\n";

        for my $port ( sort @$open ) {
            print "  $port is open\n"
              unless grep $port == $_, @$expected_open;
        }

        for my $port ( sort @$expected_open ) {
            print "  $port is closed\n"
              unless grep $port == $_, @$open;
        }
    }
}



=head1 NAME

<program> - <One-line description of programs's purpose>

=head1 SYNOPSIS

monport [options] [IP ADDRESS(ES)|SUBNET]

  options:
    -h, -?, --help  brief help message

=head1 DESCRIPTION

A full description of the <program> and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).

=head1 EXAMPLES

Print out a short help message and exit:

    <program> -h

=cut
