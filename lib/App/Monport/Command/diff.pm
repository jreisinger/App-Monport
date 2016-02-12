# ABSTRACT: check for differences by comparing base scan and actual state
package App::Monport::Command::diff;
use App::Monport -command;
use App::Monport::Nmap;

=head1 DESCRIPTION

diff sub-command. See App::Cmd::Tutorial for more.

=cut

=head1 METHODS

=head2 usage_desc()

Usage description.

=cut

sub usage_desc { "base %o" }

=head2 options()

Options.

=cut

sub options {
  return (
    [ "email|m=s@", "send differences via email instead of printing them to stdout", ],
  );
}

=head2 execute()

Run the command.

=cut

sub execute {
  my ($self, $opt, $args) = @_;

  set_vars($opt->name, $opt->nmapexe);

  if ($opt->email) {
      email_diffs(@{$opt->email});
  } else {
      print_diffs();
  }
}

=head2 validate()

Validate the command options and arguments.

=cut

sub validate {
    return "bla";
}

1;
