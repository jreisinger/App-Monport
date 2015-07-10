# ABSTRACT: create base(line) scan (used for future comparisons)
package App::Monport::Command::base;
use App::Monport -command;
use App::Monport::Nmap;

=head1 DESCRIPTION

base sub-command. See App::Cmd::Tutorial for more.

=cut

=head1 METHODS

=head2 usage_desc()

Usage description.

=cut

sub usage_desc { "base %o <target> [<target2> <target3> ... <targetN>]" }

=head2 options()

Options.

=cut

sub options {
  return (
    [ "nmapopts|o=s@", "nmap options" ],
    [ "list|l", "list existing base scan names" ],
    [ "print|p",  "print base scan results" ],
  );
}

=head2 validate()

Validate the command options and arguments.

=cut

sub validate {
  my ($self, $opt, $args) = @_;

  if ( $opt->print or $opt->list ) {
      # We don't need arguments with these options
  } else {
      $self->usage_error("no target(s) to scan") unless @$args;
  }
}

=head2 execute()

Run the command.

=cut

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
