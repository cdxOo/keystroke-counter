#!/usr/bin/env perl
use strict;
use warnings;
use POSIX qw(floor);
use Getopt::Long;

$| = 1;
$SIG{INT}  = \&onTermination;
$SIG{TERM} = \&onTermination;

my $interval = 60;
my $log = './keystroke-tracker.log';
my $keyboard = 'any';

GetOptions(
    'interval=i' => \$interval,
    'log-file=s' => \$log,
    'keyboard=s' => \$keyboard
) or die($!);

my $count = 0;
my $lastTime = makeTime();

sub findAllKeyboardIds {
    open(LIST, 'xinput list |');
    my @ids = ();
    while (<LIST>) {
        if (/id=(\d+)(?:.*slave\s*keyboard)/) {
            push(@ids, $1);
        }
    }
    close(LIST);

    return @ids;
}

sub makeTime {
    return floor(time() / $interval);
}

sub writeToDisk {
    open(FH, '>>', $log) or die($!);
    foreach (@_) {
        print FH "$_\n";
    }
    close(FH);
}

sub writeHeader () {
    writeToDisk(sprintf(
        '# start %d (interval=%d; keyboard="%s")',
        time(), $interval, $keyboard
    ));
}

sub writeFooter () {
    writeToDisk(sprintf(
        '# stop %d', time()
    ));
}

sub writeData () {
    my $timestamp = $lastTime * $interval;
    writeToDisk("$timestamp $count");
}

sub onTermination {
    writeData();
    writeFooter();
    close(XINPUT);
    die("\n");
}

my $args = undef;
if ($keyboard eq 'any') {
    my @ids = findAllKeyboardIds();
    open(XINPUT, sprintf(
        'echo %s | xargs -P0 -n1 xinput test |',
        join(' ', @ids)
    ));
}
else {
    print $keyboard;
    open(XINPUT, sprintf('xinput test "%s" |', $keyboard));
}


writeHeader();
while (<XINPUT>) {
    if (/key press/) {
        my $time = makeTime();
        if ($time != $lastTime) {
            writeData();
            $count = 0;
            $lastTime = $time;
        }
        else {
            $count += 1;
        }
    }
}
# should never run but just in case
writeFooter();
