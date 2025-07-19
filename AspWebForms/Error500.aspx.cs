using System;
using System.Web;

namespace Speedan
{
    public partial class Error500 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Establecer el código de estado HTTP correcto
            Response.StatusCode = 500;
            Response.Status = "500 Internal Server Error";
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Index.aspx");
        }
    }
}