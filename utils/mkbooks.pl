#!/usr/bin/perl

my $wc = qx(wc sample_data/cats.raw);
$wc =~ s/^ //;

my ($catmax, $dummy) = split /\s+/, $wc;

open(IN, "sample_data/ttbooks.raw") or die;

my ($auth, $isbn, $title);

while (<IN>){
   chomp;
   $author = $1 if m/Autho.*: (.*)/;   
   $isbn = $1 if m/ISBN-13: (.*)/;   
   if (m/View This Book/){
      $title = <IN>;
      chomp($title);
      $title =~ s/'/''/g;
      $author =~ s/'/''/g;
      print "INSERT INTO book (book_id, isbn, uv_author, cat_id) VALUES (seq_book_id.nextval, '$isbn','$author', trunc(dbms_random.value(1,$catmax)));\n";
      print "INSERT INTO book_info(book_id, lang_id, sale_status, translation_status_id, uv_title, uv_description)\n";
      print "VALUES(seq_book_id.currval, 1, 'ONSALE', 1, '$title', 'Description for book with title: $title');\n";
   }
}




__DATA__
                                                                                                                                                                                                                                                                                                                                                                                    

Author: Botma, Grant
ISBN-13: 9781544505411
ISBN-10: 1544505418
View This Book ›
Best Practices in Talent Management: How the World's Leading Corporations Manage, Develop, and Retain Top Talent
Best Practices in Talent Management: How the World's Leading Corporations Manage, Develop, and Retain Top Talent

