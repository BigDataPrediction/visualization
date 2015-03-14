<!--
You are free to copy and use this sample in accordance with the terms of the
Apache license (http://www.apache.org/licenses/LICENSE-2.0.html)
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>
       10 Most Popular Articles right now
    </title>
    <script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/dojo.js"
            data-dojo-config="isDebug: true,parseOnLoad: true">
    </script>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>

    <script>

        // Function that refreshes the SPAN node
        function refreshContent() {
            // Using dojo.xhrGet, as very little information is being sent
            dojo.xhrGet({
                // The URL of the request
                url: "ranking",
                // The success callback with result from server
                load: function(newContent) {

                    //dojo.byId("contentNode").innerHTML = newContent;
                    drawTable(newContent)
                },
                // The error handler
                error: function() {
                    // Do nothing -- keep old content there
                },
                // generate an extra GET variable to prevent browsers from caching
                preventCache: true
            });
        };


        // When the DOM is ready....

             require(['dojo/_base/json'], dojo.ready(function(){
            // Populate content initially
            refreshContent();
                 // refresh on 5 sec interval
            //setInterval(refreshContent,5000);
            // Connect button
            dojo.connect(dojo.byId("refreshButton"),"onclick",refreshContent);
        }));
    </script>

    <script type='text/javascript'>
        google.load('visualization', '1', {packages:['table']});
        google.setOnLoadCallback(drawTable);
        function drawTable(ranking) {
            var obj = JSON.parse(ranking);
            var articles = new Array();
            for (var key in obj) {
                var article = new Array();
                article.push(key, obj[key])
                articles.push(article)
                //console.log(article)
            }
            var data = new google.visualization.DataTable();

            data.addColumn('string', '10 Most Popular Articles at this moment');
            data.addColumn('number', 'views');
            data.addRows(articles);

            var table = new google.visualization.Table(document.getElementById('table_div'));
            table.draw(data, {width:800,showRowNumber: true});
        }
    </script>
</head>
<body style="font-family: Arial;border: 0 none;">
10 most popular articles at the moment
<div id='table_div'></div>
<p>Click the button below to refresh the content</p>

<button id="refreshButton">Refresh Content every 5 sec</button>
<br /><br />

<p id="contentNode"></p>
</body>
</html>