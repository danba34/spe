using System;
using System.Web.UI;

namespace Speedan
{
    public partial class Index : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Tu código de carga de página
        }

        // Agrega este método para manejar el evento click
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}