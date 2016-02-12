# ABSTRACT: list base scans
package App::Monport::Command::list;
use App::Monport -command;
use App::Monport::Nmap;

=head1 DESCRIPTION

list sub-command. See App::Cmd::Tutorial for more.

=cut

=head1 METHODS

=head2 usage_desc()

Usage description.

=cut

sub usage_desc { "list %o" }

=head2 options()

Options.

=cut

sub options {
  return (
    [ "print|p",  "print base scan results" ],
  );
}

=head2 validate()

Validate the command options and arguments.

=cut

sub validate {
  my ($self, $opt, $args) = @_;

  if ( $opt->print ) {
      # We don't need arguments with these options
  }
}

=head2 execute()

Run the command.

=cut

sub execute {
  my ($self, $opt, $args) = @_;

  set_vars($opt->name );

  if ($opt->print) {
      print_basescan();
  } else {
      list_basescans();
  }
}

1;
