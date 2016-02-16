package App::Monport::Command;
use strict;
use App::Cmd::Setup -command;

=head1 DESCRIPTION

Global options, i.e. options available for all sub-commands, are defined here.
See App::Cmd::Tutorial#Global-Options for more.

=cut

=head1 METHODS

=head2 opt_spec()

Global options.

=cut

sub opt_spec {
    my ( $class, $app ) = @_;
    return (
        [ 'help|h', "this usage screen" ],
        $class->options($app),
    );
}

=head2 validate_args()

Validate global arguments.

=cut

sub validate_args {
    my ( $self, $opt, $args ) = @_;
    if ( $opt->{help} ) {
        my ($command) = $self->command_names;
        $self->app->execute_command(
            $self->app->prepare_command( "help", $command ) );
        exit;
    }
    $self->validate( $opt, $args );
}

1;
