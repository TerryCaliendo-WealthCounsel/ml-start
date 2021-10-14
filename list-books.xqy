
(: build the html :)
xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
    <head>
        <title>All Books</title>
    </head>
    <body>
        <h1>Books:</h1>
        <ul>
        {
            for $x in doc()/book
            let $title := $x/title
                return <li>{data($title)}</li>
        }
        </ul>
    </body>
</html>