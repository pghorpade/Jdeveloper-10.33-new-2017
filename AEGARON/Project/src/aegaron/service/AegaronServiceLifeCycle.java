package aegaron.service;

import java.sql.Connection;
import java.sql.DriverManager;

import org.apache.axis2.context.ConfigurationContext;
import org.apache.axis2.description.AxisService;
import org.apache.axis2.engine.ServiceLifeCycle;
import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;

public class AegaronServiceLifeCycle implements ServiceLifeCycle {
    private static final Log LOG = LogFactory.getLog(AegaronServiceLifeCycle.class);
    public static final String DB_CONNECTION = "aegaronconnection";
    private static final String CONNECT_STRING = "jdbc:oracle:thin:uee/ajoatmbw1s@lit106.library.ucla.edu:1521:DLCS";
    private static final String AEGARON = "aegaron";
    private static final String VALIDATION_QUERY = "SELECT 1 FROM DUAL";

    public void startUp(ConfigurationContext configurationContext, AxisService axisService) {
        LOG.info("AegaronServiceLifeCycle::startUp()");
        Connection conn = null;
                
        try {
            LOG.debug("Loading underlying JDBC driver...");
            Class.forName("oracle.jdbc.OracleDriver");
            LOG.debug("Done.");
            LOG.debug("Setting up driver...");
            //
            // First, we'll need a ObjectPool that serves as the
            // actual pool of connections.
            //
            // We'll use a GenericObjectPool instance, although
            // any ObjectPool implementation will suffice.
            //
            ObjectPool connectionPool = new GenericObjectPool(null);
            
            //
            // Next, we'll create a ConnectionFactory that the
            // pool will use to create Connections.
            // We'll use the DriverManagerConnectionFactory,
            // using the connect string passed in the command line
            // arguments.
            //
            ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(CONNECT_STRING, null);

            //
            // Now we'll create the PoolableConnectionFactory, which wraps
            // the "real" Connections created by the ConnectionFactory with
            // the classes that implement the pooling functionality.
            //
            PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, connectionPool, null, VALIDATION_QUERY, true, true, 2);
            
            //
            // Finally, we create the PoolingDriver itself...
            //
            Class.forName("org.apache.commons.dbcp.PoolingDriver");
            PoolingDriver driver = (PoolingDriver)DriverManager.getDriver("jdbc:apache:commons:dbcp:");
            
            //
            // ...and register our pool with it.
            //
            driver.registerPool(AEGARON, connectionPool);
                        
            //
            // Now we can just use the connect string "jdbc:apache:commons:dbcp:example"
            // to access our pool of Connections.
            //

            LOG.debug("Done.");
            LOG.debug("Creating connection...");
            conn = DriverManager.getConnection("jdbc:apache:commons:dbcp:"+AEGARON);
            LOG.debug("Done.");
            // Store the connection in the ConfigurationContext
            configurationContext.setProperty(DB_CONNECTION, conn);
        } catch (Exception e) {
            LOG.error("AegaronServiceLifeCycle failed to start up " + e);
        }
    }

    public void shutDown(ConfigurationContext configurationContext, 
                         AxisService axisService) {
        LOG.info("AegaronServiceLifeCycle::shutDown()");
        // closes the pool
        try {
            PoolingDriver driver = (PoolingDriver)DriverManager.getDriver("jdbc:apache:commons:dbcp:");           
            driver.closePool(AEGARON);
        } catch (Exception e) {
            LOG.error("AegaronServiceLifeCycle failed to shut down " + e);
        }
    }
}
