#!/usr/bin/perl

#sudo perl -MCPAN -e 'install WWW::Mechanize'
#sudo perl -MCPAN -e 'install HTML::Grabber'
#sudo perl -MCPAN -e 'install Data::Dumper'
#sudo perl -MCPAN -e 'install Tie::IxHash'

use WWW::Mechanize;
use HTML::Grabber;
use Data::Dumper;
use Tie::IxHash;

my %dataHash;

tie %dataHash, 'Tie::IxHash';

my $domain = 'http://seattle.craigslist.org';

my $nextLink = '/see/zip/';

my $keepPaginatingBoolean = 1;

while ($keepPaginatingBoolean) {

    print @links[0,1];

    my $mech = WWW::Mechanize->new();
    print "grabbing ".$domain.$nextLink."\n";
    $mech->get($domain.$nextLink);

    my $dom = HTML::Grabber->new( html => $mech->content );

    $dom->find('div.content')->each(sub {
        $_->find('p.row')->each(sub {
            @words = ($_->text =~ /(\w+)/g);
            $key = @words[0]." ".@words[1];
            if (exists $dataHash{$key}) {
                push ($dataHash{$key}, $_->text);
            } else {
                $dataHash{$key} = [$_->text];
            }
        });
    });

    $dom->find('div.bottompaginator a.next')->each(sub {
        $nextLink = $_->attr('href');
    });

    if ((scalar (keys %dataHash)) > 6) {
        $keepPaginatingBoolean = 0;
    }
}

print Dumper(\%dataHash);




