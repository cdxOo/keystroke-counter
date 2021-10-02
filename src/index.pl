use strict;
use POSIX qw(floor);
use Getopt::Long;

$| = 1;
$SIG{INT}  = \&onTermination;
$SIG{TERM} = \&onTermination;

my $interval = 60;
my $log = './keystroke-tracker.log';
my $keyboard = 'AT Translated Set 2 keyboard';

GetOptions(
    'interval=i' => \$interval,
    'log-file=s' => \$log,
    'keyboard' => \$keyboard
) or die($!);

my $count = 0;
my $lastTime = makeTime();

sub makeTime () {
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
    die("\n");
}

open(XINPUT, sprintf('xinput test "%s" |', $keyboard));

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
