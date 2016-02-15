# ABSTRACT: create base(line) scan that will be used for future comparisons
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
        [
            'nmapexe|e=s',
            "nmap executable (default: '/usr/bin/nmap')",
            { default => "/usr/bin/nmap" }
        ],
    );
}

=head2 validate()

Validate the command options and arguments.

=cut

sub validate {
    my ( $self, $opt, $args ) = @_;

    $self->usage_error("no target(s) to scan") unless @$args;
}

=head2 execute()

Run the command.

=cut

sub execute {
    my ( $self, $opt, $args ) = @_;

    set_vars( $opt->name, $opt->nmapexe );

    do_basescan( $opt->nmapopts, $args );
}

1;
