# ABSTRACT: create baseline scan for future comparisons
package App::Monport::Command::base;
use App::Monport -command;
use App::Monport::Nmap;

sub usage_desc { "base %o <target> [<target2> <target3> ... <targetN>]" }

sub opt_spec {
  return (
    [ "print|p",  "print base scan(s) results", ],
    [ "nmapopts|o=s@",  "nmap options", { default => [ "-Pn" ] } ],
  );
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  if ( $opt->print ) {
      # We don't need arguments for --print
  } else {
      $self->usage_error("no target(s) to scan") unless @$args;
  }
}

sub execute {
  my ($self, $opt, $args) = @_;

  if ($opt->print) {
      print_basescan();
  } else {
      do_basescan($opt->nmapopts, $args);
  }
}

1;
