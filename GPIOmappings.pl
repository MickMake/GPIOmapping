#!/usr/bin/perl

# Beer Copyright Mick Hellstrom (MickMake YouTube channel)
#	Hey, it's a trivial script, use it any old how, just keep the creds.
#	Next time you see me, buy me a beer. (Has to be Gluten Free though.)
#
# What does it do?
#	It finds all GPIOs on your SBC and prints them all out showing you
#	the mapping that have been defined. Saves having to calculate it all
#	by hand. Useful when porting RPi.GPIO python and shell scripts or
#	C code over to a new SBC.


use strict;
use warnings;
use Data::Dumper;

my ($gsDir, %ghGPIO, @sorted, $base, $label, $ngpio);
my $gsBaseDir = "/sys/class/gpio";

opendir($gsDir, $gsBaseDir);
while(readdir($gsDir))
{
	if (/^gpiochip.*/)
	{
		print("Found $_\n");

		open(FILE, "$gsBaseDir/$_/base");
		$base = <FILE>;
		close(FILE);

		open(FILE, "$gsBaseDir/$_/label");
		$label = <FILE>;
		chomp($label);
		close(FILE);

		open(FILE, "$gsBaseDir/$_/ngpio");
		$ngpio = <FILE>;
		close(FILE);

		$ghGPIO{$base}{'dir'} = "$gsBaseDir/$_";
		$ghGPIO{$base}{'label'} = $label;
		$ghGPIO{$base}{'ngpio'} = $ngpio;

	}
}
close($gsDir);

# print Dumper \%ghGPIO;
foreach $base (sort {$a <=> $b} keys(%ghGPIO))
{
	printf("\n# GPIO chip: %s\n", $ghGPIO{$base}{'dir'});
	foreach(0 .. $ghGPIO{$base}{'ngpio'})
	{
		printf("%s%d => %d\n", $ghGPIO{$base}{'label'}, $_, ($base + $_));
	}
}

