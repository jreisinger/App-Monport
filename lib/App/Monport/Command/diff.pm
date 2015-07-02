# ABSTRACT: check for differences between base scan and now
package App::Monport::Command::diff;
use App::Monport -command;
use App::Monport::Nmap;

sub usage_desc { "base %o <target> [<target2> <target3> ... <targetN>]" }

sub options {
  return (
    [ "email|e=s@", "send differences via email instead of printing them to stdout", ],
  );
}

sub execute {
  my ($self, $opt, $args) = @_;

  set_vars($opt->name, $opt->nmapexe, $opt->verbose);

  if ($opt->email) {
      email_diffs(@{$opt->email});
  } else {
      print_diffs();
  }
}

sub validate {
    return "bla";
}

1;
