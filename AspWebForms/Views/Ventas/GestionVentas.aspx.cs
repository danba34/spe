using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Speedan.Repository;
using Speedan.Models;

namespace Speedan.Views.Ventas
{
    public partial class GestionVentas : System.Web.UI.Page
    {
        private VentaRepository ventaRepository = new VentaRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
                CargarVentas();
            }
        }

        private void CargarProductos()
        {
            var productos = ventaRepository.ObtenerProductos();

            var productosConDescripcion = productos.Select(p => new
            {
                IdProducto = p.IdProducto,
                Descripcion = $"{p.Modelo} - Talla {p.Talla} - {p.Color} - ${p.Precio:N0} (Stock: {p.Stock})"
            }).ToList();

            ddlProducto.DataSource = productosConDescripcion;
            ddlProducto.DataBind();
        }

        private void CargarVentas()
        {
            var ventas = ventaRepository.ObtenerVentas();

            // Agregar cantidad desde DetalleVenta
            var ventasConDetalle = ventas.Select(v => new
            {
                v.IdVenta,
                v.NombreUsuario,
                v.FechaVenta,
                v.Total,
                Cantidad = ObtenerCantidadVenta(v.IdVenta)
            }).ToList();

            gvVentas.DataSource = ventasConDetalle;
            gvVentas.DataBind();
        }

        private int ObtenerCantidadVenta(int idVenta)
        {
            using (var connection = ventaRepository.GetConnection())
            {
                connection.Open();
                var query = "SELECT Cantidad FROM DetalleVenta WHERE IdVenta = @IdVenta";
                using (var cmd = new MySql.Data.MySqlClient.MySqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                    var result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        protected void btnCrearVenta_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = int.Parse(ddlUsuario.SelectedValue);
                int idProducto = int.Parse(ddlProducto.SelectedValue);
                int cantidad = int.Parse(txtCantidad.Text);

                if (cantidad <= 0)
                {
                    MostrarMensaje("La cantidad debe ser mayor a 0", false);
                    return;
                }

                bool resultado = ventaRepository.CrearVenta(idUsuario, idProducto, cantidad);

                if (resultado)
                {
                    MostrarMensaje("Venta creada exitosamente", true);
                    CargarVentas();
                    CargarProductos();
                    txtCantidad.Text = "1";
                }
                else
                {
                    MostrarMensaje("Error al crear la venta. Verifique el stock disponible", false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error: {ex.Message}", false);
            }
        }

        protected void gvVentas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                try
                {
                    int idVenta = int.Parse(e.CommandArgument.ToString());
                    bool resultado = ventaRepository.EliminarVenta(idVenta);

                    if (resultado)
                    {
                        MostrarMensaje("Venta eliminada exitosamente", true);
                        CargarVentas();
                        CargarProductos();
                    }
                    else
                    {
                        MostrarMensaje("Error al eliminar la venta", false);
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje($"Error: {ex.Message}", false);
                }
            }
        }

        protected void gvVentas_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvVentas.EditIndex = e.NewEditIndex;
            CargarVentas();
        }

        protected void gvVentas_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvVentas.EditIndex = -1;
            CargarVentas();
        }

        protected void gvVentas_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int idVenta = Convert.ToInt32(gvVentas.DataKeys[e.RowIndex].Value);
                TextBox txtCantidad = (TextBox)gvVentas.Rows[e.RowIndex].FindControl("txtEditCantidad");

                if (txtCantidad != null)
                {
                    int nuevaCantidad = Convert.ToInt32(txtCantidad.Text);

                    if (nuevaCantidad <= 0)
                    {
                        MostrarMensaje("La cantidad debe ser mayor a 0", false);
                        return;
                    }

                    bool resultado = ventaRepository.EditarVenta(idVenta, nuevaCantidad);

                    if (resultado)
                    {
                        MostrarMensaje("Venta actualizada exitosamente", true);
                        gvVentas.EditIndex = -1;
                        CargarVentas();
                        CargarProductos();
                    }
                    else
                    {
                        MostrarMensaje("Error al actualizar la venta. Verifique el stock disponible", false);
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error: {ex.Message}", false);
            }
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = esExito ? "mensaje success" : "mensaje error";
            lblMensaje.Visible = true;
        }
    }
}