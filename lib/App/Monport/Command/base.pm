# ABSTRACT: Create or show base(line) scans. They are used for future comparisons.
package App::Monport::Command::base;
use App::Monport -command;
use App::Monport::Nmap;

sub usage_desc { "base %o <target> [<target2> <target3> ... <targetN>]" }

sub options {
  return (
    [ "nmapopts|o=s@", "nmap options" ],
    [ "list|l", "list existing base scan names" ],
    [ "print|p",  "print base scan results" ],
  );
}

sub validate {
  my ($self, $opt, $args) = @_;

  if ( $opt->print or $opt->list ) {
      # We don't need arguments with these options
  } else {
      $self->usage_error("no target(s) to scan") unless @$args;
  }
}

sub execute {
  my ($self, $opt, $args) = @_;

  set_vars($opt->name, $opt->nmapexe);

  if ($opt->print) {
      print_basescan();
  } elsif ($opt->list) {
      list_basescans();
  } else {
      do_basescan($opt->nmapopts, $args);
  }
}

1;
