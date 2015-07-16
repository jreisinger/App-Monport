#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use File::Path qw(remove_tree);

BEGIN {
    use_ok('App::Monport::Nmap') || print "Bail out!\n";
}

##############
# set_vars() #
##############

my %fixed_scan_name = (
    "my scan"   => "my_scan",
    "My Scan"   => "My_Scan",
    "my  Scan " => "my__Scan_",
);

# Is regex substitution working correctly?
for my $name ( keys %fixed_scan_name ) {
    set_vars( $name, "/usr/bin/nmap" );
    is( $App::Monport::Nmap::scan_name,
        $fixed_scan_name{$name},
        "Scan name [$name] to directory name [$fixed_scan_name{$name}]" );
}

####################
# list_basescans() #
####################

my %scan_name = reverse %fixed_scan_name;    # invert the hash

# Save the original base directory
my $orig_base_dir = $App::Monport::Nmap::base_dir;
$App::Monport::Nmap::base_dir = "$ENV{HOME}/.monport-test";

# Create test directories for scans
for my $dir ( keys %scan_name ) {
    mkdir $App::Monport::Nmap::base_dir;
    mkdir "$App::Monport::Nmap::base_dir/$dir";
}

# Change STDOUT and print list of base scans
my ( $fh, $out );
open( $fh, ">>", \$out ) || die "Could not open $fh: $!\n";
select($fh);
list_basescans();
select(STDOUT);

# Check basescans were printed
for my $name ( split "\n", $out ) {
    is( grep( $name eq $_, values %scan_name ), 1, "Scan name [$name] listed" );
}

# Cleanup (NOTE: must be done before restoring base directory!)
remove_tree $App::Monport::Nmap::base_dir;

# Restore base directory
$App::Monport::Nmap::base_dir = $orig_base_dir;

done_testing();
