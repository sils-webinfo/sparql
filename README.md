# SPARQL

For this assignment you will write a series of SPARQL queries. You'll
use an interactive SPARQL query interface to develop each query, and
then copy and paste it into a file to check that it is correct.

## Instructions

The questions are lettered `A` through `R`. Later questions build upon
earlier ones. In many cases you can answer a question by modifying the
query for the previous question.

For each question there is a corresponding SPARQL query file with the
suffix `.rq`, for example `A.rq`. The initial contents of each query
file contain prefixes and the selected variable names to get you
started. Use the contents as a starting point for developing and
testing your query in the interactive SPARQL query interface.

Once you have a query that you think works, copy and paste it into query file.

To check if the query in `A.rq` is valid SPARQL, run:

```sh
make A.valid
```

If the query in `A.rq` is not valid SPARQL, you'll get an error.

To run the query in `A.rq` and put the results in `A-actual.csv`, run:

```sh
make A-actual.csv
```

To check if results of the `A.rq` query are correct, run:

```sh
make A.correct
```

If the results are not correct, you'll see an error like

```diff
--- A-actual.csv    2022-10-29 21:45:38.000000000 -0400
+++ A-expect.csv    2022-10-29 11:45:56.000000000 -0400
@@ -1,2 +1,2 @@
 uri
-
+http://n2t.net/ark:/39333/ncg/place/NCG03092
gmake: *** [Makefile:52: A.correct] Error 1
```

The green lines starting with `+` are the expected (correct)
results. The red lines starting with `-` are the actual (incorrect)
results.

### Skipping questions

If you want to skip a question, run:

```sh
make A.skipped
```

(Replace `A` with the letter of the question you wish to skip.)

If you change your mind about skipping questions, run:

```sh
make clean
```

### Submitting the assignment

To submit the assignment, run:

```sh
make submission.zip
```

Then submit the zip file at
<https://aeshin.org/teaching/assignment/219/submit/>

Finally, you should
[commit](https://docs.github.com/en/codespaces/developing-in-codespaces/using-source-control-in-your-codespace#committing-your-changes)
and
[push](https://docs.github.com/en/codespaces/developing-in-codespaces/using-source-control-in-your-codespace#pushing-changes-to-your-remote-repository)
the following files:

* all the files ending with `.rq`
* `description.ttl` (see [part 3](#3-constructing-dublin-core-triples) of the assignment)

## 1 Querying the NC Gazetteer

For questions A–K, use the NC Gazetteer query interface:
[[https://jena-fuseki.fly.dev/#/dataset/ncg/query]]

A. In the NC Gazetteer dataset, the predicate `skos:prefLabel` is used
to associate place URIs and place names. What is the URI for the place
named “Choggy Butte Mountain”?

B. List the predicate and the object of every triple that has the
place named “Choggy Butte Mountain” in the subject position. The list
should be sorted alphabetically by predicate, then by object.

C. What is the name of the county that Choggy Butte Mountain is in?
(Try to write this query without using the URI of the county.)

D. List the name of every place that is in the same county as Choggy
Butte Mountain. The list should be sorted alphabetically.

E. List the URI and the name of every place that has “butt”
(capitalized or uncapitalized) somewhere in its name. The list should
be sorted alphabetically by name, then by URI.

F. List the URI of each unique predicate used in the dataset. The list
should be sorted alphabetically.

G. In the NC Gazetteer dataset, the predicate `dcterms:type` is used
to associate place URIs and place types. List the URI of each unique
type (value of `dcterms:type`) used in the dataset.  The list should
be sorted alphabetically.

H. List the URI and the name of every creek in Orange County. The list
should be sorted alphabetically by name.

I. List the URI and name of every creek in Orange County or Chatham
County, along with the name of the county the creek is in. The list
should be sorted alphabetically by county name, then by creek name.

J. List the URI and the name of every creek in Orange County or
Chatham County, and if it has a `geojson:geometry` value associated
with it, list that as well. The list should be sorted alphabetically
by county name, then by creek name.

K. List the URI and the name of every creek in Orange County or
Chatham County that does **not** have a `geojson:geometry` value
associated with it. The list should be sorted alphabetically by county
name, then by creek name.

## 2 Querying Wikidata

For questions L–Q, use the Wikidata query interface:
[[https://query.wikidata.org]]

Remember that you’ll want to include the following clause in your
query to get English-language labels for things:

```sparql
SERVICE wikibase:label { bd:serviceParam wikibase:language "en" . }
```

Read about [how the the label service
works](https://www.mediawiki.org/wiki/Wikidata_Query_Service/User_Manual#Label_service).

L. List the URI and the English label of every
[stream](http://www.wikidata.org/entity/Q47521) in [Orange
County](http://www.wikidata.org/entity/Q507957). The list should be
ordered alphabetically by label.

M. List the URI and the English label of every
[watercourse](http://www.wikidata.org/entity/Q355304) in Orange
County, along with the URI and the English label of of the specific
type of watercourse it is. The list should be ordered alphabetically
by watercourse label.

N. List the URI and the English label of of every
[swamp](http://www.wikidata.org/entity/Q166735) in [North
Carolina](http://www.wikidata.org/entity/Q1454). The list should be
sorted alphabetically by label, then by URI.

O. List the URI, English label, elevation, and [coordinate
location](http://www.wikidata.org/prop/direct/P625) of the ten swamps
in North Carolina having the highest [elevation above sea
level](http://www.wikidata.org/prop/direct/P2044). The list should be
ordered by elevation from highest to lowest. (Try switching to the map
view after running your query—use the 👁 icon on left above your list
of results in the Wikidata query interface.)

P. List the URI, English label and number of swamps of every [county
of North Carolina](http://www.wikidata.org/entity/Q13414758) having at
least 50 swamps. The list should be ordered alphabetically by label.

Q. List the URI, English label and number of swamps for all 100
counties in North Carolina. The list should be ordered by number of
swamps from most to least, then alphabetically by label.

## 3 CONSTRUCTing Dublin Core triples

R. For this question you will write a `CONSTRUCT` query that
constructs new triples based on the triples in your `description.ttl`
file from the previous assignment. The new triples will use properties
from the [Dublin Core Metadata Initiative (DCMI) Metadata
Terms](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/)
instead of the properties you defined.

Look at the DCMI Metadata Terms (specifically, the properties in the
`/terms/` namespace), and find two or three properties that are
similar in meaning to properties that you defined. Then write a
`CONSTRUCT` query that constructs new triples using the DCMI
properties.

Next, add your `description.ttl` file to your assignment repository
(just as you did for the previous assignment).

Then run the query to get the results. Because this query produces
results as Turtle rather than CSV, instead of running:

```sh
make R-actual.csv
```

… you should run:

```sh
make R-actual.ttl
```
