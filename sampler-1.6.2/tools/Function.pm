package Function;

use strict;

use Embedded;
use Node;

our @ISA = ('Embedded');


########################################################################


sub new ($$) {
    my ($proto, $parent) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);
    bless $self, $class;

    my $handle = $parent->{handle};
    local $_ = <$handle>;
    chomp;
    return if $_ eq '';

    $self->{parent} = $parent;
    $self->{handle} = $handle;

    /^([-+])\t([\w\$]+)\t(.+)\t(\d+)$/ or $self->malformed('function header');
    ($self->{linkage}, $self->{name}, $self->{filename}, $self->{line}) = ($1, $2, $3, $4);
    $self->{nodes} = [];

    while (my $node = new Node $self) {
	$node->{name} = @{$self->{nodes}};
	push @{$self->{nodes}}, $node;
    }

    $_->resolveSuccessors($self->{nodes}) foreach @{$self->{nodes}};

    return $self;
}


sub resolveCallees ($$$) {
    my $self = shift;
    $_->resolveCallees(@_) foreach @{$self->{nodes}};
}


sub dump ($) {
    my $self = shift;

    print "\t\tfunction $self->{name} at $self->{filename}:$self->{line}\n";
    $_->dump foreach @{$self->{nodes}};
}


########################################################################


sub dot ($) {
    my $self = shift;

    print "\t\t\tsubgraph \"cluster:$self\" {\n";
    print "\t\t\t\tcolor=blue;\n";
    print "\t\t\t\tlabel=\"$self->{name}()\";\n";
    $_->dot foreach @{$self->{nodes}};
    print "\t\t\t}\n"
}


sub dot_calls ($) {
    my $self = shift;

    print "\t\t\t\"$self\" [label=\"$self->{name}\", shape=box, color=blue];\n";

    my %callees;
    $_->count_callees(\%callees) foreach @{$self->{nodes}};

    while (my ($callee, $count) = each %callees) {
	print "\t\t\t\"$self\" -> \"$callee\"";
	print " [label=$count]" if $count > 1;
	print ";\n";
    }
}


########################################################################


1;
