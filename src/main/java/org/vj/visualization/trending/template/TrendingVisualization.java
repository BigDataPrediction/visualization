/**
 * 
 */
package org.vj.visualization.trending.template;

/**
 * @author Vijay
 *
 */

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringWriter;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import spark.Request;
import spark.Response;
import spark.Route;
import spark.Spark;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.ServerAddress;

import freemarker.template.Configuration;
import freemarker.template.Template;

public class TrendingVisualization
{
    @SuppressWarnings("deprecation")
    public static void main(String[] args) throws FileNotFoundException
    {
        final Properties prop = new Properties();

        final Configuration configuration = new Configuration();

        configuration.setClassForTemplateLoading(TrendingVisualization.class, "/");
        try
        {
            prop.load(TrendingVisualization.class.getClassLoader().getResourceAsStream("config.properties"));
            MongoClient mongoClient = new MongoClient(new ServerAddress(prop.getProperty("mongodb")));
            Spark.setPort(Integer.parseInt(prop.getProperty("webport")));
            DB database = mongoClient.getDB("user");
            final DBCollection collection = database.getCollection("ranking");
            // main page
            Spark.get("/", new Route()
            {
                @Override
                public Object handle(Request request, Response response)
                {
                    StringWriter stringWriter = new StringWriter();
                    try
                    {
                        Template template = configuration.getTemplate("trendinguitemplate.ftl");
                        BasicDBObject query = new BasicDBObject("_id", "globalRanking");
                        DBObject dbObject = collection.findOne(query);
                        String value = dbObject.get("ranking").toString();
                        Map<String, String> ranking = new HashMap<String, String>();
                        ranking.put("ranking", value);
                        template.process(ranking, stringWriter);
                    }
                    catch (Exception e)
                    {
                        e.printStackTrace();
                    }
                    return stringWriter;
                }
            }

            );
        }
        catch (UnknownHostException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }
}