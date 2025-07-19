using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Speedan.Repository;

namespace Speedan
{
    public partial class Dashboard : Page
    {
        private DashboardRepository _dashboardRepository;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (Session["Usuario"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _dashboardRepository = new DashboardRepository();

            if (!IsPostBack)
            {
                lblUsuario.Text = $"Bienvenido, {Session["Usuario"]} ({Session["Rol"]})";
                CargarDatosPrincipal();
            }
        }

        private void CargarDatosPrincipal()
        {
            try
            {
                // Cargar estadísticas
                var estadisticas = _dashboardRepository.ObtenerEstadisticas();
                lblTotalProductos.Text = estadisticas["TotalProductos"].ToString();
                lblTotalVentas.Text = estadisticas["TotalVentas"].ToString();
                lblProductosBajoStock.Text = estadisticas["ProductosBajoStock"].ToString();
                lblTotalIngresos.Text = Convert.ToDecimal(estadisticas["TotalIngresos"]).ToString("N2");

                // Cargar grid según selección
                CargarGridSegunVista();
            }
            catch (Exception ex)
            {
                // Manejo de errores
                Response.Write($"<script>alert('Error al cargar datos: {ex.Message}');</script>");
            }
        }

        private void CargarGridSegunVista()
        {
            DataTable datos = null;

            switch (ddlVista.SelectedValue)
            {
                case "ventas":
                    datos = _dashboardRepository.ObtenerResumenVentas();
                    break;
                case "productos":
                    datos = _dashboardRepository.ObtenerProductosBajoStock();
                    break;
                case "inventario":
                    datos = _dashboardRepository.ObtenerInventarioCompleto();
                    break;
            }

            if (datos != null)
            {
                // Limpiar columnas existentes
                gvPrincipal.Columns.Clear();

                // Generar columnas automáticamente
                gvPrincipal.AutoGenerateColumns = true;
                gvPrincipal.DataSource = datos;
                gvPrincipal.DataBind();

                // Aplicar estilos adicionales según la vista
                AplicarEstilosGrid();
            }
        }

        private void AplicarEstilosGrid()
        {
            if (gvPrincipal.Rows.Count > 0)
            {
                // Aplicar estilos específicos según la vista
                switch (ddlVista.SelectedValue)
                {
                    case "productos":
                        // Colorear filas según el stock
                        foreach (GridViewRow row in gvPrincipal.Rows)
                        {
                            if (row.RowType == DataControlRowType.DataRow)
                            {
                                var estadoCell = row.Cells[row.Cells.Count - 1].Text;
                                if (estadoCell == "Sin Stock")
                                    row.BackColor = System.Drawing.Color.FromArgb(255, 235, 238);
                                else if (estadoCell == "Crítico")
                                    row.BackColor = System.Drawing.Color.FromArgb(255, 243, 205);
                            }
                        }
                        break;

                    case "inventario":
                        // Colorear según el estado del inventario
                        foreach (GridViewRow row in gvPrincipal.Rows)
                        {
                            if (row.RowType == DataControlRowType.DataRow)
                            {
                                var estadoCell = row.Cells[row.Cells.Count - 1].Text;
                                if (estadoCell == "Sin Stock")
                                    row.BackColor = System.Drawing.Color.FromArgb(255, 235, 238);
                                else if (estadoCell == "Bajo Stock")
                                    row.BackColor = System.Drawing.Color.FromArgb(255, 243, 205);
                            }
                        }
                        break;
                }
            }
        }

        protected void ddlVista_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarGridSegunVista();
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            CargarDatosPrincipal();
        }

        // Métodos para manejar la navegación entre páginas
        protected void btnTabPrincipal_Click(object sender, EventArgs e)
        {
            // Ya estamos en el dashboard, no necesitamos redirigir
        }

        protected void btnTabUsuarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Usuarios/GestionUsuarios.aspx");
        }

        protected void btnTabProductos_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Productos/GestionProductos.aspx");
        }

        protected void btnTabVentas_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Ventas/GestionVentas.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}