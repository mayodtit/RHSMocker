#Better Rails Server  
![](better_icn.png)

This project includes:

1. Better App API + docs
2. Nurse Portal

##Environments
####Development
* Database: Sqlite

To generate API docs run
```
rake docs:generate
```

** Solr needs extra changes on config to make partial word searches possible. **
> change schema.xml to contain this chunk. <fieldType name="text" class="solr.TextField" omitNorms="false"> is already there, but the stuff under that directive need to merged.

```
 <fieldType name="text" class="solr.TextField" omitNorms="false">
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StandardFilterFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.EdgeNGramFilterFactory" minGramSize="1" maxGramSize="15"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StandardFilterFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>
```

####Email
Using [Sendgrid](http://sendgrid.com/) for sending out emails.

> TODOs
* make sending emails asychronous. Use one of the [delayed_job](https://github.com/collectiveidea/delayed_job), [resque](https://github.com/resque/resque), [sidekiq](http://sidekiq.org/) type of utilities
* get a [litmus](http://litmus.com/) account. It will literally save lives.

