using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Speedan.Repository;
using Speedan.Models;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace Speedan.Views.Usuarios
{
    public partial class GestionUsuarios : Page
    {
        private UsuarioRepository usuarioRepo = new UsuarioRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
            {
                Response.Redirect("../../Login.aspx");
            }

            if (!IsPostBack)
            {
                CargarUsuarios();
            }
        }

        private void CargarUsuarios()
        {
            try
            {
                var usuarios = usuarioRepo.ObtenerTodos();

                // Debug: Verificar que los usuarios tienen el rol correcto
                System.Diagnostics.Debug.WriteLine($"Usuarios obtenidos: {usuarios.Count}");
                foreach (var user in usuarios)
                {
                    System.Diagnostics.Debug.WriteLine($"Usuario: {user.NombreUsuario}, Rol: {user.Rol ?? "NULL"}");
                }

                if (usuarios != null && usuarios.Count > 0)
                {
                    gvUsuarios.DataSource = usuarios;
                    gvUsuarios.DataBind();
                }
                else
                {
                    // Crear una lista vacía para mostrar el mensaje de EmptyDataText
                    gvUsuarios.DataSource = new List<Usuario>();
                    gvUsuarios.DataBind();
                    System.Diagnostics.Debug.WriteLine("No se encontraron usuarios en la base de datos");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar usuarios: " + ex.Message, false);
                System.Diagnostics.Debug.WriteLine($"Error CargarUsuarios: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"StackTrace: {ex.StackTrace}");

                // Limpiar el GridView en caso de error
                gvUsuarios.DataSource = new List<Usuario>();
                gvUsuarios.DataBind();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones básicas
                if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text))
                {
                    MostrarMensaje("El nombre de usuario es requerido", false);
                    return;
                }

                var usuario = new Usuario
                {
                    IdUsuario = int.Parse(hfIdUsuario.Value),
                    NombreUsuario = txtNombreUsuario.Text.Trim(),
                    Contrasena = txtContrasena.Text.Trim(),
                    Rol = ddlRol.SelectedValue
                };

                bool resultado = false;
                string mensaje = "";

                if (usuario.IdUsuario == 0)
                {
                    if (string.IsNullOrWhiteSpace(usuario.Contrasena))
                    {
                        MostrarMensaje("La contraseña es requerida para usuarios nuevos", false);
                        return;
                    }
                    resultado = usuarioRepo.Insertar(usuario);
                    mensaje = resultado ? "Usuario creado exitosamente" : "Error al crear usuario";
                }
                else
                {
                    resultado = usuarioRepo.Actualizar(usuario);
                    mensaje = resultado ? "Usuario actualizado exitosamente" : "Error al actualizar usuario";
                }

                MostrarMensaje(mensaje, resultado);
                if (resultado)
                {
                    LimpiarFormulario();
                    CargarUsuarios();
                }
            }
            catch (MySqlException ex)
            {
                if (ex.Number == 1062) // Duplicate entry
                {
                    MostrarMensaje("El nombre de usuario ya existe", false);
                }
                else
                {
                    MostrarMensaje("Error de base de datos: " + ex.Message, false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al guardar usuario: " + ex.Message, false);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditarUsuario")
            {
                try
                {
                    var usuario = usuarioRepo.ObtenerPorId(id);
                    if (usuario != null)
                    {
                        hfIdUsuario.Value = usuario.IdUsuario.ToString();
                        txtNombreUsuario.Text = usuario.NombreUsuario;
                        ddlRol.SelectedValue = usuario.Rol;
                        txtContrasena.Text = ""; // No mostrar contraseña actual
                        btnGuardar.Text = "Actualizar";
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar usuario: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "EliminarUsuario")
            {
                try
                {
                    bool resultado = usuarioRepo.Eliminar(id);
                    if (resultado)
                    {
                        MostrarMensaje("Usuario eliminado exitosamente", true);
                        CargarUsuarios();
                    }
                    else
                    {
                        MostrarMensaje("No se pudo eliminar el usuario", false);
                    }
                }
                catch (MySqlException ex)
                {
                    if (ex.Number == 1451) // Foreign key constraint fails
                    {
                        MostrarMensaje("No se puede eliminar el usuario porque tiene registros relacionados en el sistema", false);
                    }
                    else
                    {
                        MostrarMensaje("Error de base de datos al eliminar: " + ex.Message, false);
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al eliminar usuario: " + ex.Message, false);
                }
            }
        }

        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Esto ayuda a asegurar que el rol se muestre correctamente
                e.Row.DataBind();
            }
        }

        private void LimpiarFormulario()
        {
            hfIdUsuario.Value = "0";
            txtNombreUsuario.Text = "";
            txtContrasena.Text = "";
            ddlRol.SelectedIndex = 0;
            btnGuardar.Text = "Guardar";
            pnlMensaje.Visible = false;
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            divMensaje.Attributes["class"] = esExito ? "alert alert-success" : "alert alert-danger";
            pnlMensaje.Visible = true;
        }
    }
}