using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace Speedan
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Código que se ejecuta al iniciar la aplicación
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    
 void Application_Error(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            // Puedes redirigir según el error si prefieres
            Exception ex = Server.GetLastError();
            Response.Redirect("~/Error500.aspx");
        }

    }
}