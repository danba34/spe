using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Speedan.Repository;
using Speedan.Models;

namespace Speedan.Views.Productos
{
    public partial class GestionProductos : Page
    {
        private ProductoRepository productoRepo = new ProductoRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
            {
                Response.Redirect("../../Login.aspx");
            }

            if (!IsPostBack)
            {
                CargarProductos();
            }
        }

        private void CargarProductos()
        {
            try
            {
                var productos = productoRepo.ObtenerTodos();
                gvProductos.DataSource = productos;
                gvProductos.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar productos: " + ex.Message, false);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Validar que la página sea válida solo para el grupo de validación del producto
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                var producto = new Producto
                {
                    IdProducto = int.Parse(hfIdProducto.Value),
                    Modelo = txtModelo.Text.Trim(),
                    Talla = decimal.Parse(txtTalla.Text),
                    Color = txtColor.Text.Trim(),
                    Precio = decimal.Parse(txtPrecio.Text),
                    Stock = int.Parse(txtStock.Text)
                };

                if (producto.IdProducto == 0)
                {
                    productoRepo.Insertar(producto);
                    MostrarMensaje("Producto creado exitosamente", true);
                }
                else
                {
                    productoRepo.Actualizar(producto);
                    MostrarMensaje("Producto actualizado exitosamente", true);
                }

                LimpiarFormulario();
                CargarProductos();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al guardar producto: " + ex.Message, false);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Editar")
            {
                try
                {
                    var producto = productoRepo.ObtenerPorId(id);
                    if (producto != null)
                    {
                        hfIdProducto.Value = producto.IdProducto.ToString();
                        txtModelo.Text = producto.Modelo;
                        txtTalla.Text = producto.Talla.ToString();
                        txtColor.Text = producto.Color;
                        txtPrecio.Text = producto.Precio.ToString();
                        txtStock.Text = producto.Stock.ToString();
                        btnGuardar.Text = "Actualizar";

                        // Scroll hacia el formulario para que el usuario vea los datos cargados
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ScrollToForm",
                            "document.querySelector('.card').scrollIntoView({ behavior: 'smooth' });", true);
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar producto: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    productoRepo.Eliminar(id);
                    MostrarMensaje("Producto eliminado exitosamente", true);
                    CargarProductos();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al eliminar producto: " + ex.Message, false);
                }
            }
        }

        protected void gvProductos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var producto = (Producto)e.Row.DataItem;
                if (producto.Stock <= 5)
                {
                    e.Row.CssClass = "low-stock";
                }
            }
        }

        private void LimpiarFormulario()
        {
            hfIdProducto.Value = "0";
            txtModelo.Text = "";
            txtTalla.Text = "";
            txtColor.Text = "";
            txtPrecio.Text = "";
            txtStock.Text = "";
            btnGuardar.Text = "Guardar";
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            divMensaje.Attributes["class"] = esExito ? "alert alert-success" : "alert alert-danger";
            pnlMensaje.Visible = true;
        }
    }
}