package PerlActor::LineTokenizer;
use strict;
use base 'PerlActor::Object';
use fields qw( tokens currentToken inQuoteMode quoteChar line placeholderValues );

use PerlActor::Exception::PlaceholderNotDefined;

#===============================================================================================
# Public Methods
#===============================================================================================

sub getTokens
{
	my ($self, $line, @placeholderValues) = @_;

	return () unless $line;
	return if $line =~ /^#/; # Comment Line

	chomp $line;

	$self->{line}              = $line;
	$self->{placeholderValues} = \@placeholderValues;
	
	$self->_reset();

	map { $self->_processChar($_)} (split //, $line);
		
	$self->_addCurrentToken();
		
	return @{$self->{tokens}};
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

sub _reset
{
	my $self = shift;
	$self->{tokens} = [];
	$self->_resetCurrentToken();
}

sub _addCurrentToken
{
	my $self = shift;
	if ($self->_hasValidCurrentToken())
	{
		push @{$self->{tokens}}, $self->{currentToken};
		$self->_resetCurrentToken();
	}
}

sub _hasValidCurrentToken
{
	my $self = shift;
	return $self->{currentToken} =~ /[^\s]/; 
}

sub _resetCurrentToken
{
	my $self = shift;
	$self->{currentToken} = '';
}

sub _processChar
{
	my ($self, $char) = @_;
	if ($self->_inQuoteMode())
	{
		$self->_processCharQuoteMode($char);
	}
	else
	{
		$self->_processCharNormalMode($char);
	}
}

sub _processCharNormalMode
{
	my ($self, $char) = @_;
	if ($char =~ /\s/)
	{
		$self->_addCurrentToken();
	}
	elsif ($self->_isQuoteChar($char))
	{
		$self->_setQuoteMode();
		$self->{quoteChar} = $char;
	}
	else
	{
		$self->{currentToken} .= $char;
	}
}

sub _processCharQuoteMode
{
	my ($self, $char) = @_;
	if ($char eq $self->{quoteChar})
	{
		$self->_addCurrentToken();
		$self->_setNormalMode();
	}
	else
	{
		$self->{currentToken} .= $char;
	}
}

sub _inQuoteMode
{
	my $self = shift;
	return $self->{inQuoteMode};
}

sub _isQuoteChar
{
	my ($self, $char) = @_;
	return $char =~ m/('|"|~)/; #'
}

sub _setQuoteMode
{
	my $self = shift;
	$self->{inQuoteMode} = 1;
}

sub _setNormalMode
{
	my $self = shift;
	$self->{inQuoteMode} = 0;
}

# Keep Perl happy.
1;
