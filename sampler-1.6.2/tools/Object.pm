package Object;

use strict;

use Embedded;
use Unit;

our @ISA = ('Embedded');


########################################################################


sub new ($$$) {
    my ($proto, $handle, $name) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new;
    bless $self, $class;

    $self->{name} = $name;
    $self->{handle} = $handle;

    push @{$self->{units}}, $_ while $_ = new Unit $self;

    return $self;
}


sub collectExports ($$) {
    my ($self, $exports) = @_;

    $_->collectExports($exports) foreach @{$self->{units}};
}


sub resolveCallees ($$) {
    my ($self, $exports) = @_;

    $_->resolveCallees($exports) foreach @{$self->{units}};
}


sub dump ($) {
    my $self = shift;

    print "object $self->{name}\n";
    $_->dump foreach @{$self->{units}};
}


########################################################################


sub dot ($) {
    my $self = shift;

    print "\tsubgraph \"cluster:$self\" {\n";
    print "\t\tcolor=red;\n";
    print "\t\tlabel=\"$self->{name}\";\n";
    $_->dot foreach @{$self->{units}};
    print "\t}\n";
}


sub dot_calls ($) {
    my $self = shift;

    print "\tsubgraph \"cluster:$self\" {\n";
    print "\t\tcolor=red;\n";
    print "\t\tlabel=\"$self->{name}\";\n";
    $_->dot_calls foreach @{$self->{units}};
    print "\t}\n";
}


########################################################################


1;
