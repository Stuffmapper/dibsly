#!/usr/bin/perl

#sudo perl -MCPAN -e 'install WWW::Mechanize'
#sudo perl -MCPAN -e 'install HTML::Grabber'
#sudo perl -MCPAN -e 'install Data::Dumper'
#sudo perl -MCPAN -e 'install Tie::IxHash'
#sudo perl -MCPAN -e 'install Text::CSV'

use WWW::Mechanize;
use HTML::Grabber;
use Data::Dumper;
use Tie::IxHash;
use Text::CSV;

my @domainValues;

my %domains;

tie %domains, 'Tie::IxHash';

$domains{'http://sfbay.craigslist.org'} = 0;
$domains{'http://albany.craigslist.org'} = 0;
$domains{'http://albuquerque.craigslist.org'} = 0;
$domains{'http://anchorage.craigslist.org'} = 0;
$domains{'http://atlanta.craigslist.org'} = 0;
$domains{'http://austin.craigslist.org'} = 0;
$domains{'http://baltimore.craigslist.org'} = 0;
$domains{'http://boise.craigslist.org'} = 0;
$domains{'http://boston.craigslist.org'} = 0;
$domains{'http://buffalo.craigslist.org'} = 0;
$domains{'http://charlotte.craigslist.org'} = 0;
$domains{'http://chicago.craigslist.org'} = 0;
$domains{'http://cincinnati.craigslist.org'} = 0;
$domains{'http://cleveland.craigslist.org'} = 0;
$domains{'http://columbus.craigslist.org'} = 0;
$domains{'http://dallas.craigslist.org'} = 0;
$domains{'http://denver.craigslist.org'} = 0;
$domains{'http://detroit.craigslist.org'} = 0;
$domains{'http://fresno.craigslist.org'} = 0;
$domains{'http://norfolk.craigslist.org'} = 0;
$domains{'http://hartford.craigslist.org'} = 0;
$domains{'http://honolulu.craigslist.org'} = 0;
$domains{'http://houston.craigslist.org'} = 0;
$domains{'http://indianapolis.craigslist.org'} = 0;
$domains{'http://kansascity.craigslist.org'} = 0;
$domains{'http://lasvegas.craigslist.org'} = 0;
$domains{'http://losangeles.craigslist.org'} = 0;
$domains{'http://louisville.craigslist.org'} = 0;
$domains{'http://memphis.craigslist.org'} = 0;
$domains{'http://milwaukee.craigslist.org'} = 0;
$domains{'http://minneapolis.craigslist.org'} = 0;
$domains{'http://nashville.craigslist.org'} = 0;
$domains{'http://neworleans.craigslist.org'} = 0;
$domains{'http://newyork.craigslist.org'} = 0;
$domains{'http://oklahomacity.craigslist.org'} = 0;
$domains{'http://omaha.craigslist.org'} = 0;
$domains{'http://orangecounty.craigslist.org'} = 0;
$domains{'http://orlando.craigslist.org/'} = 0;
$domains{'http://philadelphia.craigslist.org/'} = 0;
$domains{'http://phoenix.craigslist.org/'} = 0;
$domains{'http://pittsburgh.craigslist.org/'} = 0;
$domains{'http://portland.craigslist.org/'} = 0;
$domains{'http://raleigh.craigslist.org/'} = 0;
$domains{'http://providence.craigslist.org/'} = 0;
$domains{'http://richmond.craigslist.org/'} = 0;
$domains{'http://sacramento.craigslist.org/'} = 0;
$domains{'http://saltlakecity.craigslist.org/'} = 0;
$domains{'http://sanantonio.craigslist.org/'} = 0;
$domains{'http://sandiego.craigslist.org/'} = 0;
$domains{'http://seattle.craigslist.org/'} = 0;
$domains{'http://miami.craigslist.org/'} = 0;
$domains{'http://stlouis.craigslist.org/'} = 0;
$domains{'http://tampa.craigslist.org/'} = 0;
$domains{'http://tucson.craigslist.org/'} = 0;
$domains{'http://washingtondc.craigslist.org/'} = 0;


@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $todayKey = $months[$mon]." ".$mday;

push(@domainValues, $todayKey);

while(my($domainsKey, $domainsValue) = each %domains){
    my %dataHash;

    tie %dataHash, 'Tie::IxHash';

    my $domain = $domainsKey;

    my $nextLink = '/zip/';

    my $keepPaginatingBoolean = 1;

    while ($keepPaginatingBoolean) {

        print @links[0,1];

        my $mech = WWW::Mechanize->new();
        print "grabbing ".$domain.$nextLink."\n";
        $mech->get($domain.$nextLink);

        my $dom = HTML::Grabber->new( html => $mech->content );

        $dom->find('div.content')->each(sub {
            $_->find('p.row')->each(sub {
                $date = $_->find('span.date')->text;
                if (exists $dataHash{$date}) {
                    push ($dataHash{$date}, $_->text);
                } else {
                    $dataHash{$date} = [$_->text];
                }
            });
        });

        $dom->find('a.next')->each(sub {
            $nextLink = $_->attr('href');
        });

        if ((scalar (keys %dataHash)) > 1) {
            $keepPaginatingBoolean = 0;
        }

        print Dumper(\%dataHash);
    }

    if (exists $dataHash{$todayKey}) {
        $domains{$domainsKey} = scalar grep defined($_),values $dataHash{$todayKey};
        push(@domainValues, $domains{$domainsKey});
    } else {
        push(@domainValues, 0);
    }

}

print Dumper(\%domains);


my $csv = Text::CSV->new ( { binary => 1 } ) or die "Cannot use CSV: ".Text::CSV->error_diag ();
open my $fh, ">:encoding(utf8)", "new.csv" or die "new.csv: $!";

$csv->print($fh, [@domainValues]);

$csv->eof or $csv->error_diag();

close $fh or die "new.csv: $!";

