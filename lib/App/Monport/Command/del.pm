# ABSTRACT: delete base scans
package App::Monport::Command::del;
use strict;
use App::Monport -command;
use App::Monport::Nmap;

=head1 DESCRIPTION

del sub-command. See App::Cmd::Tutorial for more.

=cut

=head1 METHODS

=head2 usage_desc()

Usage description.

=cut

sub usage_desc { "del %o" }

=head2 options()

Options.

=cut

sub options {
}

=head2 validate()

Validate the command options and arguments.

=cut

sub validate {
    my ( $self, $opt, $args ) = @_;

    $self->usage_error("no scan to delete") unless @$args;
}

=head2 execute()

Run the command.

=cut

sub execute {
    my ( $self, $opt, $args ) = @_;

    set_vars( $opt->name );

    if ( $opt->print ) {
        print_basescan();
    } else {
        del_basescans();
    }
}

1;
