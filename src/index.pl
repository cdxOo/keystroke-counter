use strict;
use POSIX qw(floor);

$| = 1;
$SIG{INT}  = \&onTermination;
$SIG{TERM} = \&onTermination;

my $interval = 60;
my $count = 0;
my $lastTime = makeTime();

sub makeTime () {
    return floor(time() / $interval);
}

sub writeToDisk () {
    open(FH, '>>', './keystroke-tracker.log') or die($!);
    my $timestamp = $lastTime * $interval;
    print FH "$timestamp $count\n";
    close(FH);
}

sub onTermination {
    writeToDisk();
    die("\n");
}

open(XINPUT, 'xinput test "AT Translated Set 2 keyboard" |');

while (<XINPUT>) {
    if (/key press/) {
        my $time = makeTime();
        if ($time != $lastTime) {
            writeToDisk();
            $count = 0;
            $lastTime = $time;
        }
        else {
            $count += 1;
        }
    }
}
