using System;
using System.Web;

namespace Speedan
{
    public partial class Error404 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Establecer el código de estado HTTP correcto
            Response.StatusCode = 404;
            Response.Status = "404 Not Found";
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Index.aspx");
        }
    }
}