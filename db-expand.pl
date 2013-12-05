#!/usr/bin/perl
# Data format: key<tab> ... <tab>value1;value2;..;(@key1);(@key2)..
sub expand(@){
    foreach(@_){
        if(/@([-\w]+)/){ # Expand
            my $str="$`";
            foreach(grep(/^$1[,\t]/,@lines)){
                /.*[,\t]/;
                $str.="$';";
            }
            expand("$str$'");
        }else{ # Regulate
            /.*[,\t]/;
            my $m=$&;
            foreach(split(/;/,"$'")){
                print "$m$_\n" unless(/^(!.*|)$/);
            }
        }
    }
}
chomp(@lines=grep(/^[\w\d]/,<>)) || exit 1;
expand(@lines);
