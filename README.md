# SPARQL



## Instructions

validate query

run query and get results

check if results are correct

## 1 Querying the NC Gazetteer

For questions A–K, use the NC Gazetteer query interface:
https://jena-fuseki.fly.dev/#/dataset/NCG/query

A. In the NC Gazetteer dataset, the predicate `skos:prefLabel` is used to associate place URIs and place names. What is the URI for the place named “Choggy Butte Mountain”? 

B. List the predicate and the object of every triple that has the place named “Choggy Butte Mountain” in the subject position. The list should be sorted alphabetically by predicate, then by object.

C. What is the name of the county that Choggy Butte Mountain is in? (Try to write this query without using the URI of the county.)

D. List the name of every place that is in the same county as Choggy Butte Mountain. The list should be sorted alphabetically.

E. List the URI and the name of every place that has “butt” (capitalized or uncapitalized) somewhere in its name. The list should be sorted alphabetically by name, then by URI.

F. List the URI of each unique predicate used in the dataset. The list should be sorted alphabetically.

G. In the NC Gazetteer dataset, the predicate `dcterms:type` is used to associate place URIs and place types. List the URI of each unique type (value of `dcterms:type`) used in the dataset.  The list should be sorted alphabetically.

H. List the URI and the name of every creek in Orange County. The list should be sorted alphabetically by name.

I. List the URI and name of every creek in Orange County or Chatham County, along with the name of the county the creek is in. The list should be sorted alphabetically by county name, then by creek name.

J. List the URI and the name of every creek in Orange County or Chatham County, and if it has a `geojson:geometry` value associated with it, list that as well. The list should be sorted alphabetically by county name, then by creek name.

K. List the URI and the name of every creek in Orange County or Chatham County that does **not** have a `geojson:geometry` value associated with it. The list should be sorted alphabetically by county name, then by creek name.

## 2 Querying Wikidata

For questions L–Q, use the Wikidata query interface: 
https://query.wikidata.org

Remember that you’ll want to include the following clause in your query to get English-language labels for things:

```
SERVICE wikibase:label { bd:serviceParam wikibase:language "en" . }
```

Read about [how the the label service works](https://www.mediawiki.org/wiki/Wikidata_Query_Service/User_Manual#Label_service).

L. List the URI and the name of every [stream](http://www.wikidata.org/entity/Q47521) in [Orange County](http://www.wikidata.org/entity/Q507957).

M. List the URI and the name of every [watercourse](http://www.wikidata.org/entity/Q355304) in Orange County, along with the URI and the name of of the specific type of watercourse it is.

N. List the URI and the name of of every [swamp](http://www.wikidata.org/entity/Q166735) in [North Carolina](http://www.wikidata.org/entity/Q1454). (You should get over 500 results.)

O. List the URI, name, elevation, and [coordinate location](http://www.wikidata.org/prop/direct/P625) of the ten swamps in North Carolina having the highest [elevation above sea level](http://www.wikidata.org/prop/direct/P2044). (Try switching to the map view after running your query—use the 👁 icon on left above your list of results in the Wikidata query interface.)

P. List the URI, name and number of swamps of every [county of North Carolina](http://www.wikidata.org/entity/Q13414758) having at least 50 swamps.

Q. List the URI, name and number of swamps for all 100 counties in North Carolina.

## 3 CONSTRUCTing Dublin Core triples

R. For this question you will write a `CONSTRUCT` query that constructs new triples based on the triples in your `description.ttl` file from the previous assignment. The new triples will use properties from the [Dublin Core Metadata Initiative (DCMI) Metadata Terms](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/) instead of the properties you defined. Look at the DCMI Metadata Terms (specifically, the properties in the `/terms/` namespace), and find two or three properties that are similar in meaning to properties that you defined. Then write a `CONSTRUCT` query that constructs new triples using the DCMI properties.

