xquery version "1.0-ml";


declare function local:sanitizeInput($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","")
};



(: build the html :)
xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
    <head>
        <title>Search Books</title>
    </head>
    <body>
        <form name="add-book" action="" method="post">
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
                <input type="submit" value="Search"/>
            </fieldset>
        </form>  

        <div>
            {
                let $queryTerm := "al"
                return
                <div>
                        {

                            if (xdmp:get-request-method() eq "POST") then (
                                let $title as xs:string? := local:sanitizeInput(xdmp:get-request-field("title"))
                                let $author as xs:string? := local:sanitizeInput(xdmp:get-request-field("author"))
                                let $year as xs:string? := local:sanitizeInput(xdmp:get-request-field("year"))
                                let $price as xs:string? := local:sanitizeInput(xdmp:get-request-field("price"))
                                let $category as xs:string? := local:sanitizeInput(xdmp:get-request-field("category"))
                                
                                return
                                    <div>
                                        <h1>Search Results: {$title}</h1>
                                        <ul>
                                        {
                                            for $book in doc()/book
                                            let $modCategory := if ( sql:trim($category) = '') then ( '.*' ) else ("^" || $category || "$")
                                            where $book/title[matches(., $title, "i")]
                                                and  $book/author[matches(., $author, "i")]
                                                and  $book/year[matches(., $year, "i")]
                                                and  $book/price[matches(., $price, "i")]
                                                and  $book[@category[matches(., $category, "i")]] 
                                            return <li>{data($book/title)}</li>
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