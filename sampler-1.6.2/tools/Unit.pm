package Unit;

use strict;

use Embedded;
use Function;
use SymbolTable;

our @ISA = ('Embedded');


########################################################################


our $verbose = 0;


sub new ($$) {
    my ($proto, $parent) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new($parent);
    bless $self, $class;

    my $handle = $parent->{handle};
    local $_ = <$handle>;
    return unless defined $_;
    chomp;
    return if $_ eq '';

    $_ eq "*\t0.1" or $self->malformed('compilation unit signature');

    $self->{name} = <$handle>;
    chomp $self->{name};

    $self->{signature} = <$handle>;
    chomp $self->{signature};

    $self->{handle} = $handle;
    $self->{functions} = new SymbolTable;

    warn 'reading ', $self->name, "\n" if $verbose;

    while (my $function = new Function $self) {
	my $name = $function->{name};
	$self->{functions}->add($function);
    }

    return $self;
}


sub collectExports ($$) {
    my ($self, $exports) = @_;

    warn 'collecting exports from ', $self->name, "\n" if $verbose;

    foreach (values %{$self->{functions}}) {
	$exports->add($_) if $_->{linkage} eq '+';
    }
}


sub resolveCallees ($$) {
    my ($self, $exports) = @_;

    warn 'resolving callees for ', $self->name, "\n" if $verbose;

    foreach (values %{$self->{functions}}) {
	$_->resolveCallees($self->{functions}, $exports);
    }
}


sub dump ($) {
    my $self = shift;

    print "\tunit $self->{name}\n";
    $_->dump foreach $self->{functions}->sort;
}


########################################################################


sub dot ($) {
    my $self = shift;

    print "\t\tsubgraph \"cluster:$self\" {\n";
    print "\t\tcolor=green;\n";
    print "\t\t\tlabel=\"$self->{name}\";\n";
    $_->dot foreach values %{$self->{functions}};
    print "\t\t}\n";
}


sub dot_calls ($) {
    my $self = shift;

    print "\t\tsubgraph \"cluster:$self\" {\n";
    print "\t\tcolor=green;\n";
    print "\t\t\tlabel=\"$self->{name}\";\n";
    $_->dot_calls foreach values %{$self->{functions}};
    print "\t\t}\n";
}


########################################################################


1;
