
(: build the html :)
xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
    <head>
        <title>Search Books</title>
    </head>
    <body>
        <form name="add-book" action="add-book.xqy" method="post">
            <fieldset>
                <legend>Search Book</legend>
                <label for="title">Title</label> <input type="text" id="title" name="title"/>
                <label for="author">Author</label> <input type="text" id="author" name="author"/>
                <label for="year">Year</label> <input type="text" id="year" name="year"/>
                <label for="price">Price</label> <input type="text" id="price" name="price"/>
                <label for="category">Category</label>
                <select name="category" id="category">
                    <option/>
                    {
                    for $c in ('CHILDREN','FICTION','NON-FICTION')
                    return
                        <option value="{$c}">{$c}</option>
                    }
                </select>
                <input type="submit" value="Save"/>
            </fieldset>
        </form>  

        <div>
            {
                let $queryTerm := "al"
                return
                <div>
                        {
                            if (fn:exists($queryTerm) and $queryTerm ne '') then (
                                <div>
                                    <h1>Search Results</h1>
                                    <ul>
                                    {
                                        for $book in doc()/book
                                        where $book/title[matches(., $queryTerm, "i")]
                                        return <li>{$book}</li>
                                    }
                                    </ul>
                                </div>
                            ) else ()
                        }
                </div>
            }
        </div>
        
    </body>
</html>