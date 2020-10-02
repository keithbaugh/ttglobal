#!/usr/bin/perl

open(IN, "cats.raw") or die;

my ($cat, $catp);

%catids = ();
my $seq = 0;
my $last_seq=0;


my %parent_at_level = ();
$parent_at_level{0}='';;
my $last_level=0;
my $txt='';
my $parent='';

while (<IN>){
   chomp;
   if (m/(\s*)\* (.*)/){
      $l = $1;
      $txt = $2;
      $level = length($l);
      $seq++;
      if ($level eq $lastlevel){
         $parent = $parent_at_level{$level};
      }elsif($level > $last_level){
         $parent_at_level{$level} = $last_seq;
         $parent = $parent_at_level{$level};
      }else{
         $parent = $parent_at_level{$level};
      }
      print "PROMPT adding: $seq - $parent - $level = $txt\n";
      $parent = 'NULL' if $parent eq '';
      print "INSERT INTO category(cat_id, parent_cat_id) VALUES ($seq, $parent);\n";
      print "INSERT INTO category_info(cat_id, lang_id, uv_category_description, translation_status_id) VALUES ($seq, 1, '$text', 1);\n";
      $last_level = $level;
      $last_seq = $seq;
   }
      
}




__DATA__
                                                                                                                                                                                                                                                                                                                                                                                    

* Biography
    * Memoir
        * Autobiography
            * Slave narrative
            * Spiritual autobiography
        * Bildungsroman
            * Contemporary slave narrative
            * Neo-slave narrative
* Commentary
* Creative nonfiction
* Critique
    * Canonical criticism
    * Form criticism
    * Higher criticism
    * Historical criticism
    * Lower criticism
    * Narrative criticism
    * Postmodern criticism
    * Psychological criticism
    * Redaction criticism
    * Rhetorical criticism
    * Social criticism
    * Source criticism
    * Textual criticism
* Cult literature
* Diaries and journals
* Didactic
    * Dialectic
    * Rabbinic
    * Aporetic
    * Elenctic
* Erotic literature
* Essay, treatise
* History
    * Academic history
    * Genealogy
    * Narrative
    * People's history
    * Popular history
    * Official history
    * Narrative history
    * Whig history
* Lament
* Law
    * Ceremonial
    * Family
    * Levitical
    * Moral
    * Natural
    * Royal decree
    * Social
* Letter
* Manuscript
* Philosophy
    * Metaphysics
    * Socratic dialogue
* Poetry
* Religious text
    * Apocalyptic
    * Apologetics
    * Chant
    * Confession
    * Covenant
    * Creed
    * Daily devotional
    * Epistle
        * Pauline epistle
        * General epistle
        * Encyclical
    * Gospel
    * Homily
    * Koan
    * Lectionary
    * Liturgy
    * Mysticism
    * Occult literature
    * Prayer
    * Philosophy
        * Philosophical theology
        * Philosophy of religion
        * Religious epistemology
    * Prophecy
        * Blessing/Curse
        * Messianic prophecy
        * Divination
        * Oracle
            * Woe oracle
        * Prediction
        * Vision
    * Revelation
        * Natural revelation
        * Special revelation
    * Scripture
        * Buddhist texts
            * Lotus Sutra
            * Tripitaka
        * Christian literature
            * Apocrypha
            * Christian devotional literature
            * Encyclical
            * New Testament
            * Old Testament
            * Patristic
                * Anti-Nicene
                * Post-Nicene
            * Psalms
                * Imprecatory psalm
            * Pseudepigrapha
        * Hindu literature
            * Bhagavad Gita
            * Vedas
        * Islamic literature
            * Haddith
            * Quran
        * Jewish literature
            * Hebrew poetry
    * Song
        * Dirge
        * Hymn
    * Sutra
    * Theology
        * Apologetics
        * Biblical theology
        * Cosmology
        * Christology
        * Ecclesiology
        * Eschatology
        * Hamartiology
        * Pneumatology
        * Mariology
        * Natural theology
        * Soteriology
        * Theology proper
    * Wisdom literature
* Scientific writing
* Testament
* True crime
