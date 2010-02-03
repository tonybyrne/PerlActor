package PerlActor::Script;

use strict;

use base 'PerlActor::Object';
use fields qw( lines name currentLine currentLineNumber placeholderValues );

use Error qw( :try );

use PerlActor::CommandFactory;
use PerlActor::LineTokenizer;
use PerlActor::NullListener;
use PerlActor::Exception::AssertionFailure;
use PerlActor::Exception::CommandFailed; 
use PerlActor::Exception::CommandAborted; 
use PerlActor::Line;

#===============================================================================================
# Public Methods
#===============================================================================================

sub new
{
	my $proto = shift;
	my $self = $proto->SUPER::new(@_);
	$self->{name} = shift;
	$self->{lines} = [];
	$self->{placeholderValues} = [];
	$self->setContext( {} );
	$self->setListener( new PerlActor::NullListener() );
	return $self;
}

sub setLines
{
	my $self = shift;
	my @lines = @_;
	$self->{lines} = \@lines;
}

sub getName
{
	my $self = shift;
	return $self->{name};
}

sub execute
{
	my $self = shift;

	my $listener = $self->getListener();
	$listener->scriptStarted($self);	

	try
	{
		$self->_processLines();
		$listener->scriptPassed($self);
		$listener->scriptEnded($self);
	}
	catch PerlActor::Exception::CommandFailed with
	{
		my $exception = shift;
		$listener->scriptFailed($self, $exception);
		$listener->scriptEnded($self);
	}
	catch PerlActor::Exception::CommandAborted with
	{
		my $exception = shift;
		$listener->scriptAborted($self, $exception);
	};
}

sub executeCommand
{
	my ($self, $command) = @_;

	my $listener = $self->getListener();
	$command->setContext($self->getContext());
	$command->setListener($listener);
	$listener->commandStarted($self, $command);
	my $success;
	try
	{
		$command->execute();
		$listener->commandPassed($self, $command);
		$listener->commandEnded($self, $command);	
	}
	catch PerlActor::Exception::AssertionFailure with
	{
		my $exception = shift;
		$listener->commandFailed($self, $command, $exception);
		$listener->commandEnded($self, $command);
		throw PerlActor::Exception::CommandFailed("$exception\n");
	}
	otherwise
	{
		my $exception = shift;
		$listener->commandAborted($self, $command, $exception);
		throw PerlActor::Exception::CommandAborted("$exception\n");
	};
}

sub parse
{
	my $self = shift;
	return $self->_parseLines(@{$self->{lines}});
}

sub getTraceInfo
{
	my $self = shift;
	my $name = $self->getName();
	my $line = $self->trim($self->{currentLine});
	return "in $name at '$line', line $self->{currentLineNumber}";
}

sub parseLine
{
	my ($self, $line) = @_;
	
	my $modifiedLine = PerlActor::Line->substitutePlaceHolders($line, $self->getPlaceholderValues());
	
	my $tokenizer = new PerlActor::LineTokenizer();
	my @tokens = $tokenizer->getTokens($modifiedLine);

	return unless @tokens;
		
	my $factory = new PerlActor::CommandFactory();
	my $command = $factory->create(@tokens);
	
	return $command;
}

sub setPlaceholderValues
{
	my ($self, @values) = @_;
	$self->{placeholderValues} = \@values;
}

sub getPlaceholderValues
{
	my $self = shift;
	return @{$self->{placeholderValues}};
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

sub _parseLines
{
	my ($self, @lines) = @_;
	my @commands;
	foreach my $line (@lines)
	{
		push @commands, $self->parseLine($line);
	}
	return @commands;
}

sub _processLines
{
	my $self = shift;

	$self->{currentLineNumber} = 0;
	foreach my $line (@{$self->{lines}})
	{
		$self->_processLine($line);
	}
}

sub _processLine
{
	my ($self, $line) = @_;
	chomp $line;
	$self->{currentLine} = $line;
	$self->{currentLineNumber}++;
	my $command = $self->parseLine($line);
	return unless $command;
	$self->executeCommand($command);
}

# Keep Perl happy.
1;
