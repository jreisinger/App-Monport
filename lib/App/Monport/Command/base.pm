# ABSTRACT: create base(line) scan for future comparisons
package App::Monport::Command::base;
use App::Monport -command;
use App::Monport::Nmap;

sub usage_desc { "base %o <target> [<target2> <target3> ... <targetN>]" }

sub options {
  return (
    [ "nmapopts|o=s@",  "nmap options (default: '-Pn')", { default => [ "-Pn" ] } ],
    [ "print|p",  "print base scan(s) results (default: 'noname')", ],
  );
}

sub validate {
  my ($self, $opt, $args) = @_;

  if ( $opt->print ) {
      # We don't need arguments for --print
  } else {
      $self->usage_error("no target(s) to scan") unless @$args;
  }
}

sub execute {
  my ($self, $opt, $args) = @_;

  set_vars($opt->name, $opt->nmapexe, $opt->verbose);

  if ($opt->print) {
      print_basescan();
  } else {
      do_basescan($opt->nmapopts, $args);
  }
}

1;
