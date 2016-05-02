options(encoding="UTF-8")

library(httr)
library(rjstat)

url <- "http://data.ssb.no/api/v0/no/table/08434"
data <- '{
        "query":[
                {"code":"Region",
                "selection":{
                        "filter":"all",
                        "values":["*"]
                }
                },
                {"code":"Bosettingsstatus",
                "selection":{
                        "filter":"item",
                        "values":["00","01","02"]
                }},
                {"code":"Landbakgrunn",
                "selection":{
                        "filter":"item",
                        "values":["000","0000","009"]
                }},
                {"code":"ContentsCode",
                "selection":
                        {"filter":"item",
                        "values":["Sysselsatte"]
                }},
                {"code":"Tid",
                "selection":{
                        "filter":"top",
                        "values":["3"]
                }}
        ],
        "response":{
                "format":"json-stat"
        }
}'

d.tmp <- POST(url , body = data, encode = "json", verbose())

# Henter ut innholdet fra d.tmp som tekst deretter bearbeides av fromJSONstat
sbtabell <- fromJSONstat(content(d.tmp, "text"))

# Henter ut kun datasettet fra sbtabell
ds <- sbtabell[[1]]

# Viser datasettet
ds

# Trekker ut noen av dataene
tabell <- ds[ which(ds$region=="00 Alle fylker" & ds$bosettingsstatus=="Alle sysselsatte" & ds$landbakgrunn=="Alle land"), ]

# Barplott av den kjedelige sorten
barplot(tabell$value, names.arg = tabell$`kvartal (u)`)