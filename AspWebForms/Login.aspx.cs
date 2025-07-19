using System;
using System.Web;
using System.Web.UI;
using Speedan.Repository;

namespace Speedan
{
    public partial class Login : Page
    {

        private UsuarioRepository _usuarioRepository;

        protected void Page_Load(object sender, EventArgs e)
        {
            _usuarioRepository = new UsuarioRepository(); 
        {
        //    throw new Exception("🔥 **Error de prueba** - Esto es solo para verificar Error500.aspx");
        }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string usuario = txtUsuario.Text.Trim();
            string contrasena = txtContrasena.Text.Trim();

            if (string.IsNullOrEmpty(usuario) || string.IsNullOrEmpty(contrasena))
            {
                MostrarError("Por favor ingrese usuario y contraseña");
                return;
            }

            var usuarioValidado = _usuarioRepository.ValidarUsuario(usuario, contrasena);

            if (usuarioValidado != null)
            {
                // Guardar datos del usuario en la sesión
                Session["UsuarioId"] = usuarioValidado.IdUsuario;
                Session["Usuario"] = usuarioValidado.NombreUsuario;
                Session["Rol"] = usuarioValidado.Rol;

                // Redirigir al dashboard
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                MostrarError("Usuario o contraseña incorrectos");
            }
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            lblError.Visible = true;
        }
    }
}